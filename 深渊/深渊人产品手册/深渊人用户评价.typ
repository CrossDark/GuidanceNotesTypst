#import "@preview/ourchat:0.2.2" as oc
#import oc.themes: *

#let developer = discord.user(
  name: [Dev],
  avatar: circle(fill: purple, text(white)[D])
)
#let admin = discord.user(
  name: [Admin],
  avatar: circle(fill: red, text(white)[A])
)

#discord.chat(
  oc.time[Today at 2:14 PM],

  oc.message(left, developer)[
```python
def optimize_query():
    return cache_strategy.redis_cluster()
```
    What do you think about this approach? @admin
  ],

  oc.message(right, admin)[
    @developer Looks good! The Redis cluster should handle the load well.
  ],
)