GDPC                                                                                  res://project.binary       u      u�4}��7�# j�(L4   res://src/Extensions/KeyDisplay/KeyDisplay.gd.remap �      ?       Լ��|�%1$q�B�0   res://src/Extensions/KeyDisplay/KeyDisplay.gdc  @      �      7��E����!v./
n0   res://src/Extensions/KeyDisplay/KeyDisplay.tscn 0	      2	      摀*08��<3Y'�?��,   res://src/Extensions/KeyDisplay/Main.tscn   p      �      F�d��\�ְ�c?l�j0   res://src/Extensions/KeyDisplay/extension.json  �      �       �e�$d��H�!�֏�            GDSC   &      +   0     �����������Ѷ���   �����϶�   ���������������ض���   ������Ӷ   ������������������ض   �嶶   ����������Ӷ   ��������Ӷ��   ��������   �����¶�   ����¶��   ���������¶�   ��Ҷ   ����ڶ��   ������������Ķ��   ������������Ķ��   ����ڶ��   ������������Ŷ��   ����Ӷ��   ��϶   ������������϶��   ������Ҷ   ���¶���   ������������������Ѷ   ����������������Ӷ��   ���¶���   ��������޶��   ��������������������ض��   �����������ζ���   �����������   �������Ӷ���   ����Ķ��   ����ݶ��   �����������ⶶ��   ������������󶶶   ����Ӷ��   ���������Ӷ�   ���������Ӷ�             @              +        Left      Right         Middle                                       !      %      &   	   '   
   2      @      P      U      [      a      b      n      v      �      �      �      �      �      �      �      �      �      �      �      �      �       �   !   �   "   �   #   �   $     %     &      '   !  (   "  )   *  *   .  +   3YYY0�  PQX=V�  �  PQT�  �  �  P�  T�  �  �  �  Q�  �  PQYYY0�	  P�
  V�  QX=V�  ;�  W�  �  �  �  �  �  ;�  W�  �  �  �  �  �  �  ;�  �  �  &�
  4�  V�  &�
  T�  VY�  ;�  �  T�  P�
  T�  Q�  &�  T�  �  V�  &�  T�  T�  P�>  P�  QQV�  �  �>  P�  T�  R�  R�  Q�  (V�  .�  (V�  �  �>  P�  Q�  �  T�  �>  P�  QY�  &�
  4�  V�  &�
  T�  V�  &�
  T�  �  V�  �  T�  P�  QT�  �  T�   �  '�
  T�  �!  V�  �  T�  P�  QT�  �  T�   �  '�
  T�  �"  V�  �  T�  P�  QT�  �  T�   �  (V�  �  T�  P�  QT�  �  T�#  �  �  T�  P�  QT�  �  T�#  �  �  T�  P�  QT�  �  T�#  YYY0�$  PQX=V�  �%  PQY`   [gd_scene load_steps=2 format=2]

[ext_resource path="res://src/Extensions/KeyDisplay/KeyDisplay.gd" type="Script" id=1]

[node name="KeyDisplay" type="WindowDialog"]
margin_right = 266.0
margin_bottom = 98.0
window_title = "Key Display"
script = ExtResource( 1 )

[node name="Panel" type="Panel" parent="."]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 1
size_flags_vertical = 3
__meta__ = {
"_editor_description_": ""
}

[node name="VBoxContainer" type="VBoxContainer" parent="Panel"]
anchor_right = 1.0
anchor_bottom = 1.0
alignment = 1

[node name="HBoxContainer" type="HBoxContainer" parent="Panel/VBoxContainer"]
margin_top = 15.0
margin_right = 266.0
margin_bottom = 82.0

[node name="Panel" type="Panel" parent="Panel/VBoxContainer/HBoxContainer"]
modulate = Color( 0.768627, 0.768627, 0.768627, 1 )
margin_right = 212.0
margin_bottom = 67.0
size_flags_horizontal = 3

[node name="Label" type="Label" parent="Panel/VBoxContainer/HBoxContainer/Panel"]
anchor_right = 1.0
anchor_bottom = 1.0
size_flags_horizontal = 3
align = 1
valign = 1
autowrap = true
clip_text = true
__meta__ = {
"_edit_use_anchors_": false
}

[node name="Mouse" type="ColorRect" parent="Panel/VBoxContainer/HBoxContainer"]
margin_left = 216.0
margin_right = 266.0
margin_bottom = 67.988
rect_min_size = Vector2( 50, 67.988 )
color = Color( 0.517647, 0.517647, 0.517647, 1 )

[node name="VBoxContainer" type="VBoxContainer" parent="Panel/VBoxContainer/HBoxContainer/Mouse"]
anchor_right = 1.0
anchor_bottom = 1.0
rect_min_size = Vector2( 50, 0 )
__meta__ = {
"_edit_use_anchors_": false
}

[node name="HBoxContainer" type="HBoxContainer" parent="Panel/VBoxContainer/HBoxContainer/Mouse/VBoxContainer"]
margin_right = 50.0
margin_bottom = 25.0
rect_min_size = Vector2( 0, 25 )

[node name="Left" type="ColorRect" parent="Panel/VBoxContainer/HBoxContainer/Mouse/VBoxContainer/HBoxContainer"]
margin_right = 15.0
margin_bottom = 25.0
size_flags_horizontal = 3

[node name="Middle" type="ColorRect" parent="Panel/VBoxContainer/HBoxContainer/Mouse/VBoxContainer/HBoxContainer"]
margin_left = 19.0
margin_right = 31.0
margin_bottom = 25.0
rect_min_size = Vector2( 12, 0 )

[node name="Right" type="ColorRect" parent="Panel/VBoxContainer/HBoxContainer/Mouse/VBoxContainer/HBoxContainer"]
margin_left = 35.0
margin_right = 50.0
margin_bottom = 25.0
size_flags_horizontal = 3
              [gd_scene load_steps=2 format=2]

[ext_resource path="res://src/Extensions/KeyDisplay/KeyDisplay.tscn" type="PackedScene" id=1]

[node name="Main" type="Control"]
self_modulate = Color( 0.470588, 0.470588, 0.470588, 1 )
mouse_filter = 1
__meta__ = {
"_editor_description_": ""
}

[node name="KeyDisplay" parent="." instance=ExtResource( 1 )]
margin_right = 261.0
margin_bottom = 96.0
{
    "name": "KeyDisplay",
    "display_name": "Key Display",
    "description": "a simple key Display for Tutorials",
    "author": "Variable",
    "version": "0.2",
    "license": "MIT",
    "nodes": [
        "Main.tscn"
    ]
}
       [remap]

path="res://src/Extensions/KeyDisplay/KeyDisplay.gdc"
 ECFG      application/config/name      
   KeyDisplay     application/run/main_scene8      /   res://src/Extensions/KeyDisplay/KeyDisplay.tscn )   physics/common/enable_pause_aware_picking         $   rendering/quality/driver/driver_name         GLES2   %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2                     