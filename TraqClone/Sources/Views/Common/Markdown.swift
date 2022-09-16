import JavaScriptCore
import SwiftUI
import WebKit

public struct Markdown {
    private static var renderer: JSValue?
    private let htmlString: String

    public init(_ content: String) {
        guard Markdown.renderer != nil else {
            fatalError("Initialize the renderer first for performance reasons.")
        }

        let result = Markdown.render(content)

        htmlString = result ?? ""
    }

    public static func inizializeRenderer() {
        guard Markdown.renderer == nil else { return }

        let jsString = try? String(
            contentsOf: Bundle.module.url(
                forResource: "main.bundle",
                withExtension: "js"
            )!
        )

        let context = JSContext(virtualMachine: JSVirtualMachine())
        context?.evaluateScript(jsString)

        let module = context?.objectForKeyedSubscript("main")
        let markdown = module?.objectForKeyedSubscript("Markdown")
        let renderer = markdown?.objectForKeyedSubscript("render")

        Markdown.renderer = renderer
    }

    private static func render(_ content: String) -> String? {
        guard let renderer = Markdown.renderer else {
            fatalError("For performance reasons, initialize the renderer first.")
        }

        let result = renderer.call(withArguments: [content])
        return result?.objectForKeyedSubscript("renderedText")?.toString()
    }
}

extension Markdown: UIViewRepresentable {
    public func makeUIView(context _: Context) -> WKWebView {
        WKWebView()
    }

    public func updateUIView(_ uiView: WKWebView, context _: Context) {
        DispatchQueue.main.async {
            uiView.loadHTMLString(htmlString, baseURL: nil)
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    let content: String = ""

    static var previews: some View {
        Markdown(
            """
            # h1
            ## h2
            ### h3
            #### h4
            ##### h5
            ###### h6
            *italic* **bold** ***italic-bold***

            $1+1=2$
            !!aaa!!
            """
        )
    }
}
