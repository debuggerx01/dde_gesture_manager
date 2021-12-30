# markdown_core

Parse markdown and render it into rich text.

![show](https://xia-weiyang.github.io/gif/markdown_core.gif)

``` dart
Markdown(
    data: markdownDataString,
    linkTap: (link) => print('点击了链接 $link'),
    textStyle: // your text style ,
    image: (imageUrl) {
      print('imageUrl $imageUrl');
      return // Your image widget ;
    },
)
```
