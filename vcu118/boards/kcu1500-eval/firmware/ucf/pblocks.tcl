# define PBlocks for all quads

# KU115 quads, clock-wise from top right
set quads {
  { 233  1  9 }
  { 232  1  8 }
  { 231  1  7 }
  { 230  1  6 }
  { 229  1  5 }
  { 228  1  4 }
  { 227  1  3 }
  { 226  1  2 }
  { 225  1  1 }
  { 224  1  0 }
  { 126  0  2 }
  { 127  0  3 }
  { 128  0  4 }
  { 131  0  7 }
  { 132  0  8 }
  { 133  0  9 }
}
for {set i 0} {$i < [ llength $quads ] } {incr i} {
    set quadline [ lindex $quads $i ]
    set quadid  [ lindex $quadline 0 ]
    set quadix  [ lindex $quadline 1 ]
    set quadiy  [ lindex $quadline 2 ]
    set bq [create_pblock quad_$quadid]
    ### Slice coordinates go from X=0 to X=12 on the left, and X=130 to X=142
    ###  Each quad is 60 units in Y, so from 0 to 599 for 10 quads
    set slice_x1 [ expr ($quadix * 130) + 0 ]
    set slice_x2 [ expr ($quadix * 130) + 12 ]
    set slice_y1 [ expr ($quadiy * 60) + 0 ]
    set slice_y2 [ expr ($quadiy * 60) + 59 ]
    set slice_range SLICE_X${slice_x1}Y${slice_y1}:SLICE_X${slice_x2}Y${slice_y2}
    resize_pblock $bq -add $slice_range
    set_property  gridtypes {RAMB36 RAMB18 SLICE} $bq
    add_cells_to_pblock $bq "gen_buffers\[${i}\].buffs"
}


