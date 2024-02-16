"""
> SNAKE MINIMALIST 

> GROUP :
-  Nathan 
-  Raphaël 

> SNAKE
Game grid consisting of 21x21 squares (being 25x25 in size), 
with a border around it of the same size as one square.

> CONTROLS :
- Use the arrow keys to move the snake around the grid
  Up
  Down
  Left 
  Right

> PROJET FINAL SNAKE - Programmation sur les moteurs de jeux

> GROUP :
-  Nathan 
-  Raphaël 

> SNAKE
Grille de jeu composé de 21x21 cases (étant de taille 25x25), 
en comptant une bordure autour de celle-ci étant de même taille d'une case.

> CONTROLES :
- Touches directionelles.
"""
extends Node2D

# Initialisation des variables :
var snake = [Vector2(11,6), Vector2(11,5)] # Le snake est composé au départ de 2 cases au position (11,6) et (11,5)
var pos_point = Vector2() # Position du point actuelle
var pos_direction = Vector2(0,1) # Position de la direction ou va le joueur actuellement
var direction = "" # Position ou le joueur veut aller (up,down,left,right)



func put_point(): # met un point aléatoirement, sans que ce soit dans le snake
	var rng = RandomNumberGenerator.new() # générateur random
	rng.randomize()
	pos_point.x = rng.randi_range(1,21) # entre 1 et 21 pour x
	pos_point.y = rng.randi_range(1,21) # entre 1 et 21 pour y
	if snake.has(pos_point): # Mais si on tombe sur une position déjà occuper par le snake
		put_point() # On recommence

func rmv_end(): # enleve le dernier élement du snake
	snake.pop_back()

func add_first(): # ajoutte en première position du snake
	snake = [snake[0]+pos_direction] + snake # On ajoute l'élément ou on va, qui est donc l'ancien élément + la direction ou on va

func check_pos(): # retourne false si on arrive sur un point
	if pos_point == snake[0]: # Si on arrive a la position du point
		return false
	return true

func get_input(): # input de l'utilisateur avec les touches directionelles
	if Input.is_action_pressed("ui_up"):
		direction = "up"
	elif Input.is_action_pressed("ui_down"):
		direction = "down"
	elif Input.is_action_pressed("ui_left"):
		direction = "left"
	elif Input.is_action_pressed("ui_right"):
		direction = "right"

func check_input(): # vérifie qu'on ne fait pas de marche arrière
	if direction == "up": # Si on veut aller en haut
		if pos_direction.x != 0: # Il ne faut pas que l'on soit déjà en train d'aller en haut (cela ne change rien) ou en bas (marche arrière interdite)
			pos_direction = Vector2(0,-1)
	elif direction == "down": # Si on veut aller en bas
		if pos_direction.x != 0: # Il ne faut pas que l'on soit déjà en train d'aller en bas (cela ne change rien) ou en haut (marche arrière interdite)
			pos_direction = Vector2(0,1)
	elif direction == "left": # Si on veut aller a gauche
		if pos_direction.y != 0: # Il ne faut pas que l'on soit déjà en train d'aller a gauche (cela ne change rien) ou a droite (marche arrière interdite)
			pos_direction = Vector2(-1,0)
	elif direction == "right": # Si on veut aller a droite
		if pos_direction.y != 0: # Il ne faut pas que l'on soit déjà en train d'aller a droite (cela ne change rien) ou a gauche (marche arrière interdite)
			pos_direction = Vector2(1,0)

func check_dead(): # retourne true si on touche un mur ou soi même
	if snake[0].x == 0 or snake[0].x == 22 or snake[0].y == 0 or snake[0].y == 22: # Si le snake se cogne contre la bordure
		return true
	for i in range(len(snake)): # On parcourt chaque élément du snake
		if i != 0: # En faisant attention a ne pas comparer sa "tête" avec sa "tête"
			if snake[0] == snake[i]: # Si le snake se cogne contre soi même
				return true
	return false



func _ready():
	# Ajout d'un timer pour executer le code a un certain délai
	var _timer = Timer.new()
	_timer.name = "timer"
	self.add_child(_timer)
	_timer.connect("timeout", self, "main")
	_timer.set_wait_time(0.2) # Mouvement toute les 0.2s
	_timer.start()
	# Met le premier point a manger
	put_point()

func main(): # Boucle principale
	# Prend la direction du joueur avec les touches
	check_input()
	# Avancement du snake
	add_first()
	# Si on ne mange pas de point
	if check_pos():
		rmv_end() # On enleve le dernier élément du snake
	else:
		put_point() # On met un nouveau point
	# Si on touche un mur ou soi même
	if check_dead():
		self.get_node("timer").stop() # Le jeu se met sur "pause" -> Game over
	# Update de l'écran de jeu (_draw)
	else:
		update()

func _process(_delta): # permet de prendre en compte l'input des touches a chaque frame
	get_input()

func _draw(): # permet d'affiche l'ensemble des éléments du jeu
	# background
	draw_rect(Rect2(Vector2(0,0),Vector2(575,575)),Color(0,0,0))
	# bordure
	draw_rect(Rect2(Vector2(0,0),Vector2(575,25)),Color(0.75,0.75,0.75,1)) # haut
	draw_rect(Rect2(Vector2(0,0),Vector2(25,575)),Color(0.75,0.75,0.75,1)) # droite
	draw_rect(Rect2(Vector2(550,0),Vector2(25,575)),Color(0.75,0.75,0.75,1)) # gauche
	draw_rect(Rect2(Vector2(0,550),Vector2(575,25)),Color(0.75,0.75,0.75,1)) # bas
	# snake
	for i in snake:
		draw_rect(Rect2(Vector2(i.x*25,i.y*25),Vector2(25,25)),Color(1,1,1))
	# point
	draw_rect(Rect2(Vector2(pos_point.x*25,pos_point.y*25),Vector2(25,25)),Color(1,0,0))
	pass
