GDPC                                                                            
   D   res://.import/Decoration.png-a78f6b1b1a9f8c2e3202b5c0e0dd70a0.stex         h       �."���;�~u��j�   res://project.binary�            Y	��6�w}VͶ_��<   res://src/Extensions/AverageColor/Elements/Averager.gd.remap       H       ��{�\��7it�D��8   res://src/Extensions/AverageColor/Elements/Averager.gdc �            ���J{q=#6��Rj�W[8   res://src/Extensions/AverageColor/Elements/Averager.tscn�	      A      ?��J�c��'������@   res://src/Extensions/AverageColor/Graphics/Decoration.png.import�      �      N�V��ܩ���^���:0   res://src/Extensions/AverageColor/Main.gd.remap P      ;       ��:�����C>1�m3,   res://src/Extensions/AverageColor/Main.gdc  p      �      �%;���Bԅ�͟8��,   res://src/Extensions/AverageColor/Main.tscn @      �       Rc�aX͉�����=�E0   res://src/Extensions/AverageColor/extension.json�            P?\��lP&Q���3^    GDSC   "      ,   	     ������������Ķ��   �������������ض�   �����������Ķ���   ���������Ķ�   ����������Ķ   ����������ض   ����������������ض��   �����������ض���   ������Ӷ   ����Ŷ��   ���Ӷ���   �����϶�   �������Ӷ���   �����¶�   ����¶��   ���������¶�   ��������������������ض��   ����Ķ��   �������Ӷ���   ��������Ķ��   Ķ��   ��������Ѷ��   Ѷ��   ��������Զ��   Զ��   ��������׶��   ׶��   ��������¶��   �������������������������¶�   ������Ҷ   �����������ζ���   �����������   �����������Ķ���   �����������ⶶ��      /root/Tools       @                   
                              #   	   $   
   )      *      +      3      :      ;      <      G      M      U      [      c      i      m      n      o      u      �      �      �      �      �       �   !   �   "   �   #   �   $   �   %   �   &   �   '   �   (   �   )   �   *   �   +     ,   3YY5;�  W�  Y;�  V�  Y;�  V�  Y;�  V�  Y;�  V�  Y;�  V�  YY;�	  V�
  YYY0�  PQX=V�  �	  �  PQYYY0�  P�  V�  QX=V�  &�  4�  V�  &�  �  T�  V�  �  �  T�  �  &�  �  T�  V�  �  �  T�  �  �  PQYYY0�  PQV�  ;�  P�  T�  �  T�  Q�  �  ;�  P�  T�  �  T�  Q�  �  ;�  P�  T�  �  T�  Q�  �  ;�  P�  T�  �  T�  Q�  Y�  �  �  P�  R�  R�  R�  Q�  W�  �  T�  �  YYY0�  P�  V�  QX=V�  &�	  V�  &�  4�  V�  &�  T�  V�  &�  T�  �  V�  �	  T�   P�  R�  Q�  '�  T�  �!  V�  �	  T�   P�  R�!  QY`   [gd_scene load_steps=3 format=2]

[ext_resource path="res://src/Extensions/AverageColor/Graphics/Decoration.png" type="Texture" id=1]
[ext_resource path="res://src/Extensions/AverageColor/Elements/Averager.gd" type="Script" id=2]

[node name="Averager" type="VBoxContainer"]
margin_right = 20.0
margin_bottom = 20.0
rect_min_size = Vector2( 20, 20 )
size_flags_horizontal = 3
custom_constants/separation = 0
alignment = 1
script = ExtResource( 2 )

[node name="HBoxContainer" type="HBoxContainer" parent="."]
margin_right = 20.0

[node name="Left" type="TextureRect" parent="HBoxContainer"]
margin_right = 8.0
size_flags_horizontal = 3
texture = ExtResource( 1 )
expand = true
stretch_mode = 4
flip_v = true

[node name="Right" type="TextureRect" parent="HBoxContainer"]
margin_left = 12.0
margin_right = 20.0
size_flags_horizontal = 3
texture = ExtResource( 1 )
expand = true
stretch_mode = 4
flip_h = true
flip_v = true

[node name="AverageColor" type="Button" parent="."]
margin_right = 20.0
margin_bottom = 20.0
rect_min_size = Vector2( 20, 20 )
hint_tooltip = "Average of the two colors"
__meta__ = {
"_edit_group_": true
}

[node name="ColorRect" type="ColorRect" parent="AverageColor"]
anchor_right = 1.0
anchor_bottom = 1.0
mouse_filter = 2

[connection signal="gui_input" from="AverageColor" to="." method="_on_AverageColor_gui_input"]
               GDSTA   
             L   WEBPRIFF@   WEBPVP8L4   /@@0��?��"�G����m$']��x$�AD�'��:^��j�6�+�        [remap]

importer="texture"
type="StreamTexture"
path="res://.import/Decoration.png-a78f6b1b1a9f8c2e3202b5c0e0dd70a0.stex"
metadata={
"vram_texture": false
}

[deps]

source_file="res://src/Extensions/AverageColor/Graphics/Decoration.png"
dest_files=[ "res://.import/Decoration.png-a78f6b1b1a9f8c2e3202b5c0e0dd70a0.stex" ]

[params]

compress/mode=0
compress/lossy_quality=0.7
compress/hdr_mode=0
compress/bptc_ldr=0
compress/normal_map=0
flags/repeat=0
flags/filter=false
flags/mipmaps=false
flags/anisotropic=false
flags/srgb=2
process/fix_alpha_border=true
process/premult_alpha=false
process/HDR_as_SRGB=false
process/invert_color=false
process/normal_map_invert_y=false
stream=false
size_limit=0
detect_3d=true
svg/scale=1.0
      GDSC            �      ���Ӷ���   �����ڶ�   �������Ķ���   ������������Ķ��   ������������ݶ��   ����������������ض��   �������������ݶ�   ����������Ӷ   �������Ӷ���   ������������Ŷ��   �������������Ķ�   ������ڶ   ��������Ӷ��   �������Ӷ���   ��������Ҷ��   �����������������¶�   ����������ض   �����������ض���   ���������Ӷ�   ���������Ӷ�      /root/Global      Color Pickers      ,   ColorPickersHorizontal/LeftColorPickerButton   -   ColorPickersHorizontal/RightColorPickerButton      8   res://src/Extensions/AverageColor/Elements/Averager.tscn   +   ColorPickersHorizontal/ColorButtonsVertical                                                                  	   !   
   (      ,      :      C      L      M      X      d      j      p      v      w      x      �      �      �      �      �      3YY;�  VY;�  V�  Y;�  V�  Y;�  V�  YYY0�  PQX=V�  �  �  PQ�  &�  V�  ;�	  V�
  �  T�  T�  P�  Q�  �  �	  T�  P�  Q�  �  �	  T�  P�  QY�  �  ?P�  QT�  PQ�  �	  T�  P�  QT�  P�  Q�  �  T�  �  �  �  T�  �  �  �  T�  �  YYY0�  PQX=V�  &�  V�  &�  V�  �  T�  PQ�  �  T�  �  Y`          [gd_scene load_steps=2 format=2]

[ext_resource path="res://src/Extensions/AverageColor/Main.gd" type="Script" id=1]

[node name="Main" type="Node"]
script = ExtResource( 1 )
 {
    "name": "AverageColor",
    "display_name": "Display Color Average",
    "description": "Displays the average color of left/right color slot",
    "author": "Variable",
    "version": "0.1",
    "license": "MIT",
    "nodes": [
        "Main.tscn"
    ]
}
          [remap]

path="res://src/Extensions/AverageColor/Elements/Averager.gdc"
        [remap]

path="res://src/Extensions/AverageColor/Main.gdc"
     ECFG      application/config/name         AverageColor)   physics/common/enable_pause_aware_picking         $   rendering/quality/driver/driver_name         GLES2   %   rendering/vram_compression/import_etc         &   rendering/vram_compression/import_etc2               