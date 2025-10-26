# Experiment

## 🎯 Motive

Most OTP or PIN input packages on pub.dev rely on a list of TextEditingControllers or a bunch of
clever
workarounds to manage multiple fields.
The idea here was to do something cleaner — build a custom widget that internally uses a single
`TextEditingController` (or a custom controller) to make things leaner, faster, and easier to
manage.

I wanted to see if I could make a smarter OTP input widget that doesn’t waste memory juggling
multiple controllers.

## 🔍 Approach

At first, I considered building on top of `EditableText`, since it already does most of the heavy
lifting.
But that’s exactly what the `pinput` package does, and I didn’t want to re-wrap the same logic.
So instead, I decided to build everything from scratch.

I began by creating the input widget UI i.e. `_OtpDigitBox` — something that reacts neatly to focus
and un-focus events.
Once that part was solid, I wrote an `OtpController` to handle state management and input tracking.
By extending `ChangeNotifier`, the controller made the widget naturally reactive and easy to update.

## 📊 Outcome

The result? Honestly, pretty satisfying.
The widget looks clean, feels responsive, and for an MVP, it already does the job quite well.

It’s missing some advanced features for now, but that’s fine — the core logic works beautifully,
and the foundation feels solid enough to grow from here.

## 🧠 Learnings & Takeaways

The most challenging part was integrating with TextInputClient.
That system is deeper than it looks — I still haven’t explored every corner of it, and a few methods
are yet to be implemented.

Still, it gave me a strong understanding of how Flutter connects with the system keyboard to build
complex input widgets like TextField.
It’s a fascinating mechanism once you start piecing it together.

## 🔗 Next Steps

- Add more customization options
- Add ability to paste values directly into the field
- Add support for obscuring text (for PIN-like inputs)