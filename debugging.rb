class Debugging
  def draw_shape(window, shape)
    points = []
    shape.num_verts.times do |i|
      v = shape.vert(i).to_a
      points << v[0]
      points << v[1]
    end
    debugger
    true
    @image = TexPlay.create_image(window, 200, 200)
    @image.paint {
      polyline points, :closed => true, :color => Gosu::Color::BLUE, :fill => true
    }
  end
end
