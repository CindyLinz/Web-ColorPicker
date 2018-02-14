( module
  ( export "mem" (memory 0) )

  ( memory 0 65535 )
  ( table 3 anyfunc )
  ( elem (i32.const 0) $rgb2rgb $hsv2rgb $hsl2rgb )

  ( type $type_conv (func (param f32) (param f32) (param f32)) )
  ( func $rgb2rgb
    ( param $r f32 ) ( param $g f32 ) ( param $b f32 )
    i32.const 0
    get_local $r
    f32.store

    i32.const 4
    get_local $g
    f32.store

    i32.const 8
    get_local $b
    f32.store
  )
  ( func $hsv2rgb
    ( param $h f32 ) ( param $s f32 ) ( param $v f32 )
    ( local $c f32 ) ( local $m f32 ) ( local $hh f32 ) ( local $x f32 )

    get_local $v
      get_local $v
      get_local $s
      f32.mul
      tee_local $c
    f32.sub
    set_local $m

    get_local $h
    f32.const 6
    f32.mul
    set_local $hh

    get_local $c
      f32.const 1
        get_local $hh
          get_local $hh
          f32.const 2
          f32.div
          f32.trunc
          f32.const 2
          f32.mul
        f32.sub
        f32.const 1
        f32.sub
        f32.abs
      f32.sub
    f32.mul
    set_local $x

    get_local $hh
    f32.const 2
    f32.lt if
      i32.const 8
      get_local $m
      f32.store

      get_local $hh
      f32.const 1
      f32.lt if
        i32.const 4
        get_local $x
        get_local $m
        f32.add
        f32.store

        i32.const 0
        get_local $c
        get_local $m
        f32.add
        f32.store
      else
        i32.const 4
        get_local $c
        get_local $m
        f32.add
        f32.store

        i32.const 0
        get_local $x
        get_local $m
        f32.add
        f32.store
      end
    else
      get_local $hh
      f32.const 4
      f32.lt if
        i32.const 0
        get_local $m
        f32.store

        get_local $hh
        f32.const 3
        f32.lt if
          i32.const 8
          get_local $x
          get_local $m
          f32.add
          f32.store

          i32.const 4
          get_local $c
          get_local $m
          f32.add
          f32.store
        else
          i32.const 8
          get_local $c
          get_local $m
          f32.add
          f32.store

          i32.const 4
          get_local $x
          get_local $m
          f32.add
          f32.store
        end
      else
        i32.const 4
        get_local $m
        f32.store

        get_local $hh
        f32.const 5
        f32.lt if
          i32.const 0
          get_local $x
          get_local $m
          f32.add
          f32.store

          i32.const 8
          get_local $c
          get_local $m
          f32.add
          f32.store
        else
          i32.const 0
          get_local $c
          get_local $m
          f32.add
          f32.store

          i32.const 8
          get_local $x
          get_local $m
          f32.add
          f32.store
        end
      end
    end
  )
  ( func $hsl2rgb
    ( param $h f32 ) ( param $s f32 ) ( param $l f32 )
    ( local $c f32 ) ( local $m f32 ) ( local $hh f32 ) ( local $x f32 )

    get_local $l
      f32.const 1
        get_local $l
        f32.const 2
        f32.mul
        f32.const 1
        f32.sub
        f32.abs
      f32.sub
      get_local $s
      f32.mul
      tee_local $c

      f32.const 2
      f32.div
    f32.sub
    set_local $m

    get_local $h
    f32.const 6
    f32.mul
    set_local $hh

    get_local $c
      f32.const 1
        get_local $hh
          get_local $hh
          f32.const 2
          f32.div
          f32.trunc
          f32.const 2
          f32.mul
        f32.sub
        f32.const 1
        f32.sub
        f32.abs
      f32.sub
    f32.mul
    set_local $x

    get_local $hh
    f32.const 2
    f32.lt if
      i32.const 8
      get_local $m
      f32.store

      get_local $hh
      f32.const 1
      f32.lt if
        i32.const 0
        get_local $c
        get_local $m
        f32.add
        f32.store

        i32.const 4
        get_local $x
        get_local $m
        f32.add
        f32.store
      else
        i32.const 0
        get_local $x
        get_local $m
        f32.add
        f32.store

        i32.const 4
        get_local $c
        get_local $m
        f32.add
        f32.store
      end

    else
      get_local $hh
      f32.const 4
      f32.lt if
        i32.const 0
        get_local $m
        f32.store

        get_local $hh
        f32.const 3
        f32.lt if
          i32.const 4
          get_local $c
          get_local $m
          f32.add
          f32.store

          i32.const 8
          get_local $x
          get_local $m
          f32.add
          f32.store
        else
          i32.const 4
          get_local $x
          get_local $m
          f32.add
          f32.store

          i32.const 8
          get_local $c
          get_local $m
          f32.add
          f32.store
        end
      else
        i32.const 4
        get_local $m
        f32.store

        get_local $hh
        f32.const 5
        f32.lt if
          i32.const 8
          get_local $c
          get_local $m
          f32.add
          f32.store

          i32.const 0
          get_local $x
          get_local $m
          f32.add
          f32.store
        else
          i32.const 8
          get_local $x
          get_local $m
          f32.add
          f32.store

          i32.const 0
          get_local $c
          get_local $m
          f32.add
          f32.store
        end
      end
    end
  )

  ;; mem layout:
  ;;   [0, 12) for output of func XXX2rgb
  ;;   [12, 12+width*height*4) for area_img.data
  ;;   [12+width*height*4, 12+width*height*4+20*height*4) for bar_img.data
  ( func $preserve_memory
    ( param $width i32 ) ( param $height i32 )
    ( local $need i32 )

    get_local $width
    i32.const 20
    i32.add
    get_local $height
    i32.mul
    i32.const 2
    i32.shl
    i32.const 65547
    i32.add
    i32.const 16
    i32.shr_u
    tee_local $need
    current_memory

    i32.gt_u if
      get_local $need
      current_memory
      i32.sub
      grow_memory
      drop
    end
  )
  ( func $draw1 (export "draw1")
    ( param $conv_index i32 ) ( param $choose_x f32 ) ( param $choose_y f32 ) ( param $choose_bar f32 ) ( param $width i32 ) ( param $height i32 )
    ( local $y i32 ) ( local $x i32 ) ( local $area_p i32 ) ( local $bar_p i32 )
    ( local $t f32 )

    get_local $width
    get_local $height
    call $preserve_memory

    get_local $width
    get_local $height
    i32.mul
    i32.const 4
    i32.mul
    i32.const 12
    i32.add
    tee_local $area_p

    get_local $height
    i32.const 80
    i32.mul
    i32.add
    set_local $bar_p

    get_local $height
    set_local $y
    ( block $end ( loop $loop
      get_local $y
      i32.const 1
      i32.sub
      tee_local $y
      i32.const 0
      i32.lt_s br_if $end

        get_local $y
        f32.convert_s/i32
          get_local $height
          i32.const 1
          i32.sub
          f32.convert_s/i32
        f32.div
        get_local $choose_x
        get_local $choose_y
      (call_indirect (type $type_conv) (get_local $conv_index))

      i32.const 20
      set_local $x
      ( block $end ( loop $loop
        get_local $x
        i32.const 1
        i32.sub
        tee_local $x
        i32.const 0
        i32.lt_s br_if $end

        get_local $bar_p
        i32.const 4
        i32.sub
        tee_local $bar_p

        i32.const 0
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8

        get_local $bar_p
        i32.const 4
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_s/f32
        i32.store8 offset=1

        get_local $bar_p
        i32.const 8
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=2

        get_local $bar_p
        i32.const 255
        i32.store8 offset=3

        br $loop
      ) )

      get_local $width
      set_local $x
      ( block $end ( loop $loop
        get_local $x
        i32.const 1
        i32.sub
        tee_local $x
        i32.const 0
        i32.lt_s br_if $end

          get_local $choose_bar
          get_local $x
          f32.convert_s/i32
            get_local $width
            i32.const 1
            i32.sub
            f32.convert_s/i32
          f32.div
          get_local $y
          f32.convert_s/i32
            get_local $height
            i32.const 1
            i32.sub
            f32.convert_s/i32
          f32.div
        (call_indirect (type $type_conv) (get_local $conv_index))

        get_local $area_p
        i32.const 4
        i32.sub
        tee_local $area_p

        i32.const 0
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8

        get_local $area_p
        i32.const 4
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=1

        get_local $area_p
        i32.const 8
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=2

        get_local $area_p
        i32.const 255
        i32.store8 offset=3

        br $loop
      ) )

      br $loop
    ) )
  )
  ( func $draw2 (export "draw2")
    ( param $conv_index i32 ) ( param $choose_x f32 ) ( param $choose_y f32 ) ( param $choose_bar f32 ) ( param $width i32 ) ( param $height i32 )
    ( local $y i32 ) ( local $x i32 ) ( local $area_p i32 ) ( local $bar_p i32 )
    ( local $t f32 )

    get_local $width
    get_local $height
    call $preserve_memory

    get_local $width
    get_local $height
    i32.mul
    i32.const 4
    i32.mul
    i32.const 12
    i32.add
    tee_local $area_p

    get_local $height
    i32.const 80
    i32.mul
    i32.add
    set_local $bar_p

    get_local $height
    set_local $y
    ( block $end ( loop $loop
      get_local $y
      i32.const 1
      i32.sub
      tee_local $y
      i32.const 0
      i32.lt_s br_if $end

        get_local $choose_y
        get_local $y
        f32.convert_s/i32
          get_local $height
          i32.const 1
          i32.sub
          f32.convert_s/i32
        f32.div
        get_local $choose_x
      (call_indirect (type $type_conv) (get_local $conv_index))

      i32.const 20
      set_local $x
      ( block $end ( loop $loop
        get_local $x
        i32.const 1
        i32.sub
        tee_local $x
        i32.const 0
        i32.lt_s br_if $end

        get_local $bar_p
        i32.const 4
        i32.sub
        tee_local $bar_p

        i32.const 0
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8

        get_local $bar_p
        i32.const 4
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_s/f32
        i32.store8 offset=1

        get_local $bar_p
        i32.const 8
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=2

        get_local $bar_p
        i32.const 255
        i32.store8 offset=3

        br $loop
      ) )

      get_local $width
      set_local $x
      ( block $end ( loop $loop
        get_local $x
        i32.const 1
        i32.sub
        tee_local $x
        i32.const 0
        i32.lt_s br_if $end

          get_local $y
          f32.convert_s/i32
            get_local $height
            i32.const 1
            i32.sub
            f32.convert_s/i32
          f32.div
          get_local $choose_bar
          get_local $x
          f32.convert_s/i32
            get_local $width
            i32.const 1
            i32.sub
            f32.convert_s/i32
          f32.div
        (call_indirect (type $type_conv) (get_local $conv_index))

        get_local $area_p
        i32.const 4
        i32.sub
        tee_local $area_p

        i32.const 0
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8

        get_local $area_p
        i32.const 4
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=1

        get_local $area_p
        i32.const 8
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=2

        get_local $area_p
        i32.const 255
        i32.store8 offset=3

        br $loop
      ) )

      br $loop
    ) )
  )
  ( func $draw3 (export "draw3")
    ( param $conv_index i32 ) ( param $choose_x f32 ) ( param $choose_y f32 ) ( param $choose_bar f32 ) ( param $width i32 ) ( param $height i32 )
    ( local $y i32 ) ( local $x i32 ) ( local $area_p i32 ) ( local $bar_p i32 )
    ( local $t f32 )

    get_local $width
    get_local $height
    call $preserve_memory

    get_local $width
    get_local $height
    i32.mul
    i32.const 4
    i32.mul
    i32.const 12
    i32.add
    tee_local $area_p

    get_local $height
    i32.const 80
    i32.mul
    i32.add
    set_local $bar_p

    get_local $height
    set_local $y
    ( block $end ( loop $loop
      get_local $y
      i32.const 1
      i32.sub
      tee_local $y
      i32.const 0
      i32.lt_s br_if $end

        get_local $choose_x
        get_local $choose_y
        get_local $y
        f32.convert_s/i32
          get_local $height
          i32.const 1
          i32.sub
          f32.convert_s/i32
        f32.div
      (call_indirect (type $type_conv) (get_local $conv_index))

      i32.const 20
      set_local $x
      ( block $end ( loop $loop
        get_local $x
        i32.const 1
        i32.sub
        tee_local $x
        i32.const 0
        i32.lt_s br_if $end

        get_local $bar_p
        i32.const 4
        i32.sub
        tee_local $bar_p

        i32.const 0
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8

        get_local $bar_p
        i32.const 4
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_s/f32
        i32.store8 offset=1

        get_local $bar_p
        i32.const 8
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=2

        get_local $bar_p
        i32.const 255
        i32.store8 offset=3

        br $loop
      ) )

      get_local $width
      set_local $x
      ( block $end ( loop $loop
        get_local $x
        i32.const 1
        i32.sub
        tee_local $x
        i32.const 0
        i32.lt_s br_if $end

          get_local $x
          f32.convert_s/i32
            get_local $width
            i32.const 1
            i32.sub
            f32.convert_s/i32
          f32.div
          get_local $y
          f32.convert_s/i32
            get_local $height
            i32.const 1
            i32.sub
            f32.convert_s/i32
          f32.div
          get_local $choose_bar
        (call_indirect (type $type_conv) (get_local $conv_index))

        get_local $area_p
        i32.const 4
        i32.sub
        tee_local $area_p

        i32.const 0
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8

        get_local $area_p
        i32.const 4
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=1

        get_local $area_p
        i32.const 8
        f32.load
        f32.const 255
        f32.mul
        f32.nearest
        i32.trunc_u/f32
        i32.store8 offset=2

        get_local $area_p
        i32.const 255
        i32.store8 offset=3

        br $loop
      ) )

      br $loop
    ) )
  )
)
