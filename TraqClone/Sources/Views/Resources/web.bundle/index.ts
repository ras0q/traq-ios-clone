import {
  MarkdownRenderResult,
  Store,
  traQMarkdownIt,
} from '@traptitech/traq-markdown-it'

export class Markdown {
  static md: traQMarkdownIt
  static render(text: string): MarkdownRenderResult {
    if (!this.md) {
      this.md = new traQMarkdownIt(storeProvider, [], 'https://q.trap.jp')
    }

    const res = this.md.render(text)
    res.renderedText = createRenderedHTML(res.renderedText)

    return res
  }
}

const storeProvider: Store = {
  getUser: () => undefined,
  getChannel: () => undefined,
  getUserGroup: () => undefined,
  getMe: () => undefined,
  getStampByName: () => undefined,
  getUserByName: () => undefined,
  generateUserHref: () => '',
  generateUserGroupHref: () => '',
  generateChannelHref: () => '',
}

const createRenderedHTML = (renderedText: string) =>
  `
  <!DOCTYPE html>
  <html lang="ja">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
  </head>
  <body>
    <span id="markdown-body">
      ${renderedText}
    </span>
  </body>
  </html>
  `
