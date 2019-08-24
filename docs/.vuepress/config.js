module.exports = {
  title: 'PolyFYPman Documentation',
  head: [
  ],
  dest: './public/docs',
  base: '/public/docs/',
  themeConfig: {
    docsDir: 'docs',
    nav: [
      { text: 'Home', link: '/' },
      { text: 'Dev Environment', link: '/dev-environment/' },
      { text: 'Specific Features', link: '/features/' },
      { text: 'Gitlab', link: 'https://gitlab.com/chakflying/PolyFYPman/' },
    ],
    sidebar: 'auto',
    displayAllHeaders: true,
    sidebarDepth: 2
  }
}