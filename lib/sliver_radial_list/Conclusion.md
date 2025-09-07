# Experiment Conclusion

## 🎯 Motive

The idea behind building this widget was to get a deeper understanding of how `ListView` works in
Flutter.  
I also wanted to see if this could eventually be turned into a package since there aren’t many out
there right now.

## 🔍 Approach

Instead of diving straight in, I started by reading through the internals of `RenderSliverList` to
see
how Flutter manages adding/removing children on the fly and keeping large lists smooth.

Once I had a good grasp, I began tinkering with laying out children in a radial manner.  
I added customizations like being able to choose a `RadialMenuAnchor` for where the `RadialView`
should
appear, and made the visible angle adjust dynamically based on that anchor.

## 📊 Outcome

It worked pretty well overall — it feels smooth and looks cool.  
That said, I haven’t really tested it with real-world widgets or different widget types, so it’s
still early.

There’s also a sizing issue: sometimes the radial takes up more space than needed, other times
less.  
So, plenty of room for improvements before even thinking about releasing it as a package :).

## 🧠 Learnings & Takeaways

The biggest win from this experiment was understanding how `RenderSliverList` works internally and
how Flutter optimizes those massive lists without breaking a sweat.

So yeah, I’d call this one a success.

## 🔗 Next Steps

- Fix the sizing issue.
- Clean up the code with comments and proper docs.
- Test with different kinds of widgets.
- Maybe, just maybe, publish it as a package.
