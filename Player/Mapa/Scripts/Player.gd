extends KinematicBody2D

var velocidad = 110
var movimiento = Vector2()
var relacion = 0

func _ready():
	$Sprite.frame = 3
	pass # Replace with function body.

func _process(delta):
	
	_movimiento(delta)
	
	#Evita que el jugador no se salga de la ventana
	#(esta funcion no se usara luego, es ahora por comodidad)
	position.x = clamp(position.x, 0, 544)
	position.y = clamp(position.y, 0, 352)


func _movimiento(delta):
	#Reinicia el valor de la variable movimiento
	movimiento = Vector2()
	
	#Movimiento y animacion hacia la derecha
	if Input.is_action_pressed("ui_right"):
		movimiento.x += 1
		if movimiento.y == 0:
			$AnimationPlayer.play("caminandoDerecha")
		
	
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_right"):
		if movimiento.y == 0:
			$AnimationPlayer.stop()
			$Sprite.frame = 0
		
	
	#Movimiento y animacion hacia la izquierda
	if Input.is_action_pressed("ui_left"):
		movimiento.x -= 1
		if movimiento.y == 0:
			$AnimationPlayer.play("caminandoIzquierda")
		
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_left"):
		if movimiento.y == 0:
			$AnimationPlayer.stop()
			$Sprite.frame = 6
	
	
	#Movimiento y animacion hacia abajo
	if Input.is_action_pressed("ui_down"):
		movimiento.y += 1
		if movimiento.x == 0:
			$AnimationPlayer.play("caminandoAbajo")
	
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_down"):
		if movimiento.x == 0:
			$AnimationPlayer.stop()
			$Sprite.frame = 3
	
	
	#Movimiento y animacion hacia arriba
	if Input.is_action_pressed("ui_up"):
		movimiento.y -=1
		if movimiento.x == 0:
			$AnimationPlayer.play("caminandoArriba")
	
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_up"):
		if movimiento.x == 0:
			$AnimationPlayer.stop()
			$Sprite.frame = 9
	
	
	#Soluciona un bug para que el jugador no vaya más rapido
	#cuando se mueve en diagonal
	if movimiento.length() > 0:
		movimiento = movimiento.normalized() * velocidad
	
	#Modificando posicion
	position += movimiento * delta
