# Framework built on another framework!

LOVE2D is a framework written in Lua, which was famously used to code Balatro.

I got interested in LOVE2D because it allows to use shaders easily, whereas other languages like Python or C++ require some kind of obscure tinkering without certain answers, especially for MacOS users with Apple Silicon chips.

At this points my framework consists of:
### Simplest UI system
You can create empty nodes, images and text elements.
However, all of them do not support relative placings, all coordinates passed to constructors should be in world coordinates.

I still haven't met a need for this feature, so I will leave it for the older me.

### User input processing system
System actively processes mouse position and button pressed so it knows which UI node is currently in focus.
When node is focused, it will try to execute callbacks on user actions, if such are set.

Currently supported events:
- mouse pressed
- mouse release
- key pressed
- key released

All of those an be set for any node with simple methods:

``node.setAction(action)`` - for mouse
``node.setKeyAction(key, action)`` - for keyboard

### Scenes system
Scenes are usual ``.lua`` files, but inside of them you can build a node structure, which will be automaticaly loaded on the start of the app.
Each scene runs both of two above mentioned systems and is isolated from other scenes.
However, you can switch between them by calling a simple method and passing an ID of necessary scene.

### Shaders
At this point shader system is honestly pretty dumb - it just creates a canvas for every node element before drawing, and use it like a texture to pass to a shader.

Nodes have default shaders - `color` just fills the node with one color and `image` draws a textures with a colormask.
Shaders are created by passing a name to constructor and the loading from a corresponding folder.

Use ``node.shader.setParameter(name, value)`` to set a shader parameter. ``value`` here can not only be a variable, but also a function returning something.
Unfortunately, LOVE2D does not support glsl structure uniforms, so parameters are limited to arrays and simple types.

### Logger
Just a static logger with 4 types of messages:

``NOTICE`` - for debugging or regular logs
``SUCCESS`` - to highlight something nice has happened
``WARNING`` - to take attention to something wrong
``ERROR`` - for critical breakages

### Command line arguments

A few arguments which you can pass via terminal when running your LOVE2D app:

- ``--scene`` - name of the scene to be shown on load, otherwise temporary empty scene will load.
- ``--width``, ``--height`` - dimensions of the window.
- ``--gizmo`` - pass not 0 to enable debuging UI elements, like node frames, node ids and focus element badge.
- ``-v`` - show the logs produced in the app.
- ``-s`` - save the logs to a file.
