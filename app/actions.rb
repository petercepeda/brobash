module Actions

  STATES = {
    idle: 1,
    walking: 2
  }

  def states
    STATES
  end

  # Creating methods for checking specific states
  STATES.keys.each do |state_name|
    define_method "#{ state_name.to_s }?" do
      self.state == STATES[state_name]
    end
  end

  def idle
    unless idle?
      sprite.stop_all_actions and sprite.run_action idle_animation
      self.state = states[:idle]
    end
  end

  def walk_left
    walk_with_direction -1
  end

  def walk_right
    walk_with_direction 1
  end

  def walk_with_direction( direction )
    if idle?
      sprite.stop_all_actions and sprite.run_action walk_animation
      self.state = states[:walking]
    end

    if walking?
      # self.velocity = jbp(direction * self.speed, self.velocity.y)
      sprite.body.apply_force force: [direction * self.speed, 0]
      sprite.flip x: (direction >= 0) ? false : true
    end
  end

  def jump
    if on_ground? and (idle? or walking?)
      sprite.body.apply_force force: [0, self.vertical]
      self.on_ground = false
    end
  end

  def on_ground?
    self.on_ground
  end

  def animate_action( name, options = {} )
    delay = 1.0 / (options[:speed] || 12)
    repeat = options[:repeat] || true

    action_frames = SpriteFrameCache.frames.where prefix: name, suffix: '.png', from: 0
    animation = Animation.new frames: action_frames, delay: delay
    repeat ? Repeat.forever(action: animation.action) : Animate.with(action: animation.action)
  end

end