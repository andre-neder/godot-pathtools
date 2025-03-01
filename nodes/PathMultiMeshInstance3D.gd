@tool
extends Path3D
## Distribute a mesh along a path using MultiMeshInstance3D

var is_dirty = false
var multi_mesh_instance: MultiMeshInstance3D;

@export var instance_distance = 1.0 :
  set(value):
    instance_distance = value
    is_dirty = true

@export var mesh: Mesh:
  set(value):
    multi_mesh_instance.multimesh.mesh = value
    is_dirty = true
  get():
    return multi_mesh_instance.multimesh.mesh

func _enter_tree() -> void:
    multi_mesh_instance = MultiMeshInstance3D.new()
    multi_mesh_instance.multimesh = MultiMesh.new()
    multi_mesh_instance.multimesh.transform_format = MultiMesh.TRANSFORM_3D
    connect("curve_changed", _on_curve_changed)
    add_child(multi_mesh_instance, false, 1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  if is_dirty:
    _update_multimesh()
    is_dirty = false

func _update_multimesh():

  var path_length: float = curve.get_baked_length()
  
  var count: int = floor(path_length / instance_distance)

  multi_mesh_instance.multimesh.instance_count = count

  var offset = instance_distance / 2.0

  for i in range(0, count):
    var curve_distance = offset + instance_distance * i
    var segment_position = curve.sample_baked(curve_distance, true)

    var segment_basis = Basis()

    var up = curve.sample_baked_up_vector(curve_distance, true)
    var forward = segment_position.direction_to(curve.sample_baked(curve_distance + 0.1, true))

    segment_basis.y = up
    segment_basis.x = forward.cross(up).normalized()
    segment_basis.z = -forward

    var transf = Transform3D(segment_basis, segment_position)
    multi_mesh_instance.multimesh.set_instance_transform(i, transf)

func _on_curve_changed() -> void:
  print("curve changed")
  is_dirty = true
