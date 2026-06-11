```mermaid
stateDiagram-v2
    base : base
    clicked : clicked
    dragging : dragging
    released : released

    base --> clicked : LeftMouseButton
    clicked --> dragging : mouse motion
    dragging --> released : LeftMouseButton pressed or released
    released --> base : is outside drop area
    dragging --> base : RightMouseButton
```

