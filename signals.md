Define the signal in the emitting script
```python
signal died

func die():
    died.emit()
```
implement the listener on scripts that should be listening for the signal. 

```python
func _on_died():
    # Do stuff. 

```

Now you have to connect your signal to it's slot. 

```python

# in the emitting script
func _ready():
    died.connect(_scene._on_died)
```

