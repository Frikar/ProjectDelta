extends KinematicBody2D

var velocidad = 110
var movimiento = Vector2()
var estadoDialogo = false
var cooldownInteractuar = false
var relacion = 0


signal interactuando

export (PackedScene) var cuadroTexto

func _ready():
	#Hace que Player spawnee mirando hacia abajo
	$Sprite.frame = 3

func _process(delta):
	
	if Input.is_action_just_pressed("INTERACTUAR"):
		emit_signal("interactuando")
	
	if estadoDialogo == false:
		_movimiento(delta)
		
	_dialogoNPC()
	


func _movimiento(delta):
	#Reinicia el valor de la variable movimiento
	movimiento = Vector2()
	
	#Movimiento y animacion hacia la derecha
	if Input.is_action_pressed("ui_right"):
		movimiento.x += 1
		if movimiento.y == 0:
			$AnimationPlayer.play("caminandoDerecha")
		
	
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_right") &&  movimiento.y == 0:
		$AnimationPlayer.stop()
		$Sprite.frame = 0
		
	
	#Movimiento y animacion hacia la izquierda
	if Input.is_action_pressed("ui_left"):
		movimiento.x -= 1
		if movimiento.y == 0:
			$AnimationPlayer.play("caminandoIzquierda")
		
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_left") &&  movimiento.y == 0:
		$AnimationPlayer.stop()
		$Sprite.frame = 6
	
	
	#Movimiento y animacion hacia abajo
	if Input.is_action_pressed("ui_down"):
		movimiento.y += 1
		if movimiento.x == 0:
			$AnimationPlayer.play("caminandoAbajo")
	
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_down") && movimiento.x == 0:
		$AnimationPlayer.stop()
		$Sprite.frame = 3
	
	
	#Movimiento y animacion hacia arriba
	if Input.is_action_pressed("ui_up"):
		movimiento.y -=1
		if movimiento.x == 0:
			$AnimationPlayer.play("caminandoArriba")
	
	#El jugador suelta el boton, y el personaje se detiene
	if Input.is_action_just_released("ui_up") && movimiento.x == 0:
		$AnimationPlayer.stop()
		$Sprite.frame = 9
	
	
	#Soluciona un bug para que el jugador no vaya más rapido
	#cuando se mueve en diagonal
	if movimiento.length() > 0:
		movimiento = movimiento.normalized() * velocidad
	
	#Modificando posicion
	movimiento += move_and_slide(movimiento)

func _dialogoNPC():
	if(get_slide_count() > 0):
		if(get_slide_collision(get_slide_count() - 1) != null):
			var obj_colisionado = get_slide_collision(get_slide_count() - 1).collider
			if(Input.is_action_just_pressed("INTERACTUAR") && obj_colisionado.is_in_group("NPC") && estadoDialogo == false && cooldownInteractuar == false):
				
				
				#Detienen la animacion de caminar
				if $Sprite.frame == 1 || $Sprite.frame == 2:
					$AnimationPlayer.stop()
					$Sprite.frame = 0
					
				if $Sprite.frame == 4 || $Sprite.frame == 5:
					$AnimationPlayer.stop()
					$Sprite.frame = 3
				
				if $Sprite.frame == 7 || $Sprite.frame == 8:
					$AnimationPlayer.stop()
					$Sprite.frame = 6
				
				if $Sprite.frame == 10 || $Sprite.frame == 11:
					$AnimationPlayer.stop()
					$Sprite.frame = 9
				
				
				var cuadro = cuadroTexto.instance()
				get_parent().add_child(cuadro)
				estadoDialogo = true
				cooldownInteractuar = true
				$AnimationPlayer.stop()
				var controlador = 0
				
				while controlador < obj_colisionado.texto.size():
					cuadro.get_node("Label").text = obj_colisionado.texto[controlador]
					controlador += 1
					print(controlador)
					yield(self,"interactuando")
					
				estadoDialogo = false
				get_parent().remove_child(cuadro)
				yield(get_tree().create_timer(0.1),"timeout")
				cooldownInteractuar = false
				relacion = relacion + 10
				print(relacion)
