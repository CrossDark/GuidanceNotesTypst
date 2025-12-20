#import "@preview/ourchat:0.2.2" as oc
#import oc.themes: *

#let alice = wechat.user(name: [Alice], avatar: circle(fill: blue, text(white)[A]))
#let bob = wechat.user(name: [Bob], avatar: circle(fill: green, text(white)[B]))

#wechat.chat(
  oc.time[Today 14:30],

  oc.message(left, alice)[
    Hey! How's the new project going?
  ],

  oc.message(right, bob)[
    Great! Just finished the API integration.
    The performance improvements are impressive! 🚀
  ],
)
