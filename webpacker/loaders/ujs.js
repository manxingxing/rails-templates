module.exports = {
  test: require.resolve('@rails/ujs'),
  use: [
    {
      loader: 'expose-loader',
      options: 'Rails'
    }
  ]
}
