module ActiveRecordInspection
  def t_associations
    reflections.map do |name, reflection|
      "#{reflection.macro} :#{reflection.name}, #{reflection.options}"
    end
  end

  def t_attributes
    attributes_to_define_after_schema_loads.map do |name, meta|
      "attribute :#{name}, #{meta[0]}, #{meta[1]}"
    end
  end

  def t_stored_attributes
    stored_attributes.map do |attribute, accessors|
      "attribute :#{attribute}, accessors: [#{accessors.join(', ')}]"
    end
  end

  def t_validators
    validators.map do |validator|
      case validator
      when ActiveRecord::Validations::PresenceValidator
        "validates_presence_of #{validator.attributes.join(', ')}, #{validator.options}"
      when ActiveRecord::Validations::UniquenessValidator
        "validates_uniqueness_of #{validator.attributes.join(', ')}, #{validator.options}"
      else
        "#{validator.class.name.demodulize}: #{validator.attributes.join(', ')}, #{validator.options}"
      end
    end
  end

  def t_enums
    defined_enums.map do |enum, collection|
      values = collection.map do |label, value|
        "#{label}: value"
      end
      "enum :#{enum}, { #{values.join(', ')} }"
    end
  end

  def t_callbacks
    callbacks = self.__callbacks.slice(:save, :create, :update, :destroy, :commit, :validation, :initialize, :find, :before_commit)
    memo = Hash.new {|h, k| h[k] = Hash.new{|h, k| h[k] = []} }
    callbacks.each do |type, callback_chain|
      callback_chain.group_by(&:kind).each do |kind, cbs|
        cbs.each do |cb|
          filter =
            case cb.raw_filter
            when /autosave_associated_records_for_/
            when :before_save_collection_association
            when :after_save_collection_association
            when :_ensure_no_duplicate_errors
            when Proc
              source_location = cb.raw_filter.source_location.join(":")
              source_location =~ /gems\/activerecord/ ? nil : source_location
            else
              cb.raw_filter
            end
          memo[type][kind].push(filter) if filter
        end
      end
    end # each

    memo.each do |type, cb_grouped_by_kind|
      puts "#{type}:"
      cb_grouped_by_kind.each do |kind, cbs|
        puts "  #{kind}:"
        cbs.each do |cb|
          puts "    #{cb}"
        end
      end
    end
  end # t_callbacks

  def t_polymorphic
    fields = []
    column_names.each do |field|
      if result = field.match(/([\w_]+)_type/)
        sub_fieldname = result.captures[0]
        if column_names.include?("#{sub_fieldname}_id")
          fields.push(sub_fieldname)
        end
      end
    end # each
    unless fields.empty?
      puts "多态关联: #{fields.join(', ')}"
    end
  end
end

if defined?(ActiveRecord::Base)
  ActiveRecord::Base.send(:extend, ActiveRecordInspection)
end

module ClassExtensions
  def parent_until(kls, stop_at = ActionController::Base)
    ancestors = []
    kls.ancestors.each do |k|
      next unless k.is_a?(Class)
      break if k == stop_at

      ancestors.push(k)
    end

    ancestors
  end
end

Class.send(:include, ClassExtensions)
