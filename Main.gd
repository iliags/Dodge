extends Node


export(PackedScene) var mob_scene;
var score;

# Small personal pet-peeve fixes
const PI_DIV_4 = PI / 4;
const PI_DIV_2 = PI / 2;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize();
	# Uncomment to quick test
	#new_game();

func new_game():
	$Music.play();
	score = 0;
	get_tree().call_group("mobs", "queue_free");
	$Player.start($StartPosition.position);
	$StartTimer.start();
	
	$HUD.update_score(score);
	$HUD.show_message("Get Ready");

func game_over():
	$Music.stop();
	$DeathSound.play();
	$ScoreTimer.stop();
	$MobTimer.stop();
	$HUD.show_game_over();


func _on_MobTimer_timeout():
	# Creates a mob instance
	var mob = mob_scene.instance();
	
	# Choose random spawn location along the Path2D node
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation");
	mob_spawn_location.offset = randi();
	
	# Set the position
	mob.position = mob_spawn_location.position;
	
	# Set the path perpendicular to the Path2D direction
	var direction = mob_spawn_location.rotation + PI_DIV_2;
	
	# Random direction
	direction += rand_range(-PI_DIV_4, PI_DIV_4);
	mob.rotation = direction;
	
	# Set velocity
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0);
	mob.linear_velocity = velocity.rotated(direction);
	
	# Spawn the mob by adding it to the main scene
	add_child(mob);
	

func _on_ScoreTimer_timeout():
	score += 1;
	$HUD.update_score(score);


func _on_StartTimer_timeout():
	$MobTimer.start();
	$ScoreTimer.start();
