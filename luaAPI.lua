/// @Module world

  /***
  Gets the vector between two positions, accounting for the world wrap.

  @function distance
  @position position1 {x,y} position in world coordinates
  @position position2 {x,y} position in world coordinates
  @treturn vector (position1 - position2) from position2 to position1, which
  will be correct even when around the world wrap.
  */

  /***
  Calculates the magnitude of a 2-vector table, or the magnitude of the distance between two 2-vectors.

  Accounts for world wrapping if two vectors are given.

  @function magnitude
  @Vector vector1 Vector or start point of a line segment
  @Vector vector2 If given, the magnitude of (vector1 - vector2) will be calculated
  @treturn numeric magnitude
  */

  Check if the given position collides with solid and/or platform collision.

  @function pointCollision
  @position position The { x, y } position to check
  @Bool[opt=true] solidOnly If true, will only check for solid collision,
  otherwise will include platform collision.
  @treturn bool true if the given position falls inside of a collision region
  */

  /***
  Check if the given line collides with solid and/or platform collision.

  @function lineCollision
  @position startPoint The { x, y } position of the line start point
  @position endPoint The { x, y } position of the line end point
  @Bool[opt=true] solidOnly If true, will only check for solid collision,
  otherwise will include platform collision.
  @treturn bool true if the given line intersects a collision region
  */

  /***
  Check if the given rectangle collides with solid and/or platform collision.

  @function rectCollision
  @region region region to check
  @Bool[opt=true] solidOnly If true, will only check for solid collision,
  otherwise will include platform collision.
  @treturn bool true if the given rectangle overlaps with a collision region
  */

  /***
  Gets all the tile positions along the given line that contain collision.

  @function collisionBlocksAlongLine
  @position startPoint the start of the line
  @position endPoint the end of the line
  @Bool[opt=true] solidOnly if true, will only check for solid collision,
  otherwise will include platform collision.
 @int[opt=-1] maxSize the maximum number of collision positions to return, or
  -1 for no limit.
  @return A table (array) of {x,y} positions (integral) of the tiles with
  collision, ordered by (smallest) distance to the start point.
  */

  /***
  Returns whether or not the given tile is occupied by a material or tile entity
  
  @function tileIsOccupied
  @position tilePosition the position you wish to check
  @Bool[opt=true] tileLayer true to indicate foreground and false to indicate background
  @Bool[opt=false] includeEphemeral should we return virtual collisions (such as unplaced objects being held by a player's beam)
  @return a bool indicating whether or not the tile is occupied
   */

breakObject is yet undocumented
spawnItem is yet undocumented
spawnMonster is yet undocumented
spawnNpc is yet undocumented
spawnProjectile is yet undocumented
time is yet undocumented
day is yet undocumented
timeOfDay is yet undocumented
info is yet undocumented

  /***
  Gets the force due to gravity applied at the given position.

  @function gravity
  @position position world position to get gravity at
  @treturn float the gravity at the given position
  */

itemType is yet undocumented

  /// @Module server

    /***
    Determines if the given region overlaps a player's screen region.

    @function isVisibleToPlayer
    @region region { minX, minY, maxX, maxY } region to check
    @treturn bool true if the region overlaps a player's screen region
    */

liquidAt is yet undocumented
spawnLiquid is yet undocumented
destroyLiquid is yet undocumented
loadRegion is yet undocumented

  /// @Module networkedAnimator

setAnimationState is yet undocumented
animationState is yet undocumented
animationStateProperty is yet undocumented
setGlobalTag is yet undocumented
setPartTag is yet undocumented
setFlipped is yet undocumented
rotateGroup is yet undocumented
currentRotationAngle is yet undocumented
scaleGroup is yet undocumented
currentStale is yet undocumented

  /***
  Enables or disables a particle emitter.

  The particle emitter should be listed in the `particleEmitters` section of
  the entity's *.animation file.

  @function setParticleEmitterActive
  @string name the name of the particle emitter, matching the key used in the
  `particleEmitters` section of the entity's *.animation file.
  @Bool active whether the emitter should be enabled (true) or disabled (false)
  @treturn bool true if the named particle emitter existed in the entity's
  *.animation file, false otherwise.
  */


  /***
  Triggers a one-tick emission of particles.

  The particle emitter should be listed in the `particleEmitters` section of
  the entity's *.animation file. The particles will be emitted for a single
  game tick, without modifying the `active` state of the emitter.

  @function burstParticleEmitter
  @string name the name of the particle emitter, matching the key used in the
  `particleEmitters` section of the entity's *.animation file.
  @treturn bool true if the named particle emitter existed in the entity's
  *.animation file, false otherwise.
  */

setEffectActive is yet undocumented
playImmediateSound is yet undocumented
anchorPoint is yet undocumented
stateNudge is yet undocumented

  /// @Module movementController

position is yet undocumented
setPosition is yet undocumented
translate is yet undocumented
positionDelta is yet undocumented
measuredVelocity is yet undocumented
velocity is yet undocumented
setVelocity is yet undocumented
setXVelocity is yet undocumented
setYVelocity is yet undocumented
control is yet undocumented
xControl is yet undocumented
yControl is yet undocumented
inLiquid is yet undocumented
onGround is yet undocumented
collisionBounds is yet undocumented

  /// @Module actorMovementController

walking is yet undocumented
running is yet undocumented
crouching is yet undocumented
flying is yet undocumented
falling is yet undocumented
canJump is yet undocumented
jumping is yet undocumented
direction is yet undocumented
applyMovementParameters is yet undocumented
applyMovementModifiers is yet undocumented
setRunning is yet undocumented
setCrouching is yet undocumented
setStunned is yet undocumented
setSkidding is yet undocumented
moveLeft is yet undocumented
moveRight is yet undocumented
moveDown is yet undocumented
jump is yet undocumented

  /// @Module worldDebug

logInfo is yet undocumented
debugPoint is yet undocumented
debugLine is yet undocumented
debugText is yet undocumented

  /// @Module worldEntity

  /***
  Finds all entities in the given region.

  @function entityQuery
  @position center Center of circular region to find entities in, or min position of a rect if radius param is a position
  @param[type=numeric|positon] radius If a single numeric value, the radius of the circular region.
  Can also be given a position, in which case the search region will be a rectangle defined by a min/max position.
  @param[type=table,opt] options Additional filtering options table, accepts the following:
    withoutEntityId - an entity id (numeric) that will not be returned, even
                      if it is found in the search region.
    callScript - The (string) name of a script to call in each considered
                  entity (only entities that support script calls will be
                  returned if this option is given).
    callScriptArgs - Arguments (array) passed to the script named in callScript.
    callScriptResult - Expected result of calling the script function named
                        in callScript. Only entities that return a matching
                        result will be returned. Defaults to true.
    inSightOf - an entity id that all returned entities must have line of
                sight on.
    validTargetOf - an entity id that all returned entities must be valid
                    targets of
    notAnObject - If true, no Object types will be considered. Defaults to
                  false.
    order - The desired ordering of the returned entities, only supports the
            value "nearest" which will sort the resulting entities by
            ascending distance from the center of the search region.
  @treturn table Array of entity ids
  */

  /***
  Entity query that only considers monsters.

  @function monsterQuery
  @position center
  @param[type=numeric|positon] radius
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only considers npcs.

  @function npcQuery
  @position center
  @param[type=numeric|positon] radius
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only considers placed objects.

  Adds the following options to the options argument:
    name = <only objects with this (string) name will be returned>

  @function objectQuery
  @position center
  @param[type=numeric|positon] radius
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only considers item drops.

  @function itemDropQuery
  @position center
  @param[type=numeric|positon] radius
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only considers players.

  @function playerQuery
  @position center
  @param[type=numeric|positon] radius
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only considers placed objects.

  Adds the following options to the options argument:
  orientation = Filters results that match the given orientation, valid
                values are "sit" and "lay"

  @function loungeableQuery
  @position center
  @param[type=numeric|positon] radius
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only matches entities intersecting the given line.

  @function entityLineQuery
  @position start
  @position end
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only matches placed objects intersecting the given line.

  @function objectLineQuery
  @position start
  @position end
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Entity query that only matches npcs intersecting the given line.

  @function npcLineQuery
  @position start
  @position end
  @param[type=table,opt] options
  @See entityQuery
  */

  /***
  Determines if an entity still exists in the world.

  @function entityExists
  @entityId entityId the entity to check
  @treturn bool true if the entity exists, false otherwise
  */

  /***
  Determines the general type of an entity.

  @function entityType
  @entityId entityId the entity to check
  @treturn[1] nil if the entity doesn't exist or is of an unhandled type
  @treturn[2] string entity type, which will be one of:
    "player"
    "monster"
    "object"
    "itemdrop"
    "projectile"
    "plant"
    "plantdrop"
    "effect"
    "npc"
  */

  /***
  Gets the world position of an entity.

  @function entityPosition
  @entityId entityId the entity to get the position of
  @treturn[1] nil if the entity does not exist
  @treturn[2] position world position of the entity
  */

  /***
  Gets a UUID for the given entity.

  Only valid for player entities. The UUID will remain the same even if the
  player's entity id changes.

  @function entityUuid
  @entityId entityId the entity to get the uuid of
  @treturn[1] nil if the entity doesn't exist, or is not a player
  @treturn[2] string hexadecimal UUID string (without leading '0x')
  */

  /***
  Gets the current and maximum health of an entity.
  Only valid for entities that have health (monsters, npcs, and players)

  @function entityHealth
  @entityId entityId entity to get the health of
  @treturn[1] nil if the entity does not exist or is not a monster, npc, or player
  @treturn[2] table of `{ health, maxHealth }`
  */

  /***
  Gets the species of the entity.

  Only valid for entities that have a notion of humanoid species (npcs and players)

  @function entitySpecies
  @entityId entityId entity to get the species of
  @treturn[1] nil if the entity does not exist or is not an npc or player
  @treturn[2] string species name (e.g. "apex" or "human")
  */

  /***
  Gets the name of the entity.

  The meaning of "name" depends on the type of entity:
    Player,NPC,Monster: A name for the specific entity instance, e.g. "John Doe"
    Object: The objectName value from the object's *.object config file
    ItemDrop: The itemName value from the item's *.item config file

  @function entityName
  @entityId entityId entity to get the name of
  @treturn[1] nil if the entity doesnt exist or is not of a supported type.
  @treturn[2] string entity name
  */

  /***
  Gets an item descriptor for the item held in the entity's hand.

  Only valid for entities that can hold items (npcs and players)

  @function entityHandItem
  @entityId entityId entity to get hand item of
  @string hand Name of the hand to check, accepts: "primary" or "alt"
  @treturn[1] nil if the entity doesn't exist or is not a player or NPC, or there is no item in the specified hand
  @treturn[2] string the name of the held item, as specified in an `itemName` value of a *.item config file
  */

  /***
  Gets the stage of a given Farmable Object.
  This function does not modify the crop.

  @function farmableStage
  @entityId entityId of the farmable entity
  @treturn[1] nil if the entity doesn't exist or is not a farmable object
  @treturn[2] the stage of the farmable object
  */

  /***
  Gets the size of a given Container Object.
  This function does not modify the Container.

  @function containerSize
  @entityId entityId of the container entity
  @treturn[1] nil if the entity doesn't exist or is not a container object
  @treturn[2] size of the container
  */

  /***
  Closes a given Container Object
  This function does not modify the contents of the Container.

  @function containerCloses
  @entityId entityId of the container entity
  @treturn[1] false if the entity doesn't exist or is not a container object
  @treturn[1] true otherwise
  */

  /***
  Opens a given Container Object
  This function does not modify the contents of the Container.

  @function containerOpen
  @entityId entityId of the container entity
  @treturn[1] false if the entity doesn't exist or is not a container object
  @treturn[1] true otherwise
  */

  /***
  Gets a list of item descriptors for items held in a Container Object..
  This function does not modify the Container.

  @function containerItems
  @entityId entityId of the container entity
  @treturn[1] nil if the entity doesn't exist or is not a container object
  @treturn[2] complete list of item descriptors serialized to variant with items in their container offset and order
  */

  /***
  Gets the item descriptor of the item held in a Container Object at a specific offset.
  This function does not modify the Container.

  @function containerItemAt
  @entityId entityId of the container entity
  @offset offset of the item in bag
  @treturn[1] nil if the entity doesn't exist or is not a container object or if the offset is out of range
  @treturn[2] item descriptor at given offset serialized to variant.
  */

  /***
  Consume items in Container Object from any stack that matches the given item descriptor,
  only if the entirety of the count is available.  Returns success.

  @function containerConsume
  @entityId entityId of the container entity
  @items Variant serialized items to consume
  @treturn[1] nil if the entity doesn't exist or is not a conainer object
  @treturn[2] returns whether or not the container was modified by the request successfully.
  */

  /***
  Consume count items in Container Object from given offset
  only if the entirety of the count is available.  Returns success.

  @function containerConsumeAt
  @entityId entityId of the container entity
  @offset offset of the item in bag
  @count number of items to consume
  @treturn[1] nil if the entity doesn't exist or is not a conainer object
  @treturn[2] returns whether or not the container was modified by the request successfully.
  */

  /***
  Returns the number of times the given items can be
  successfully consumed from the given Container Object..
  This function does not modify the Container.

  @function containerAvailable
  @entityId entityId of the container entity
  @items Variant serialized items to checkAvailablity
  @treturn[1] nil if the entity doesn't exist or is not a conainer object
  @treturn[2] the number of times the items can be consumed from the container
  */

  /***
  Removes all items from a Container Object. Returns items taken.

  @function containerTakeAll
  @entityId entityId of the container entity
  @treturn[1] nil if the entity doesn't exist or is not a container object
  @treturn[2] complete list of item descriptors serialized to variant with items in their container offset and order. Note: does not auto combine items.
  */

  /***
  Removes all the items held in a Container Object at a specific offset. Returns the items taken.

  @function containerTakeAt
  @entityId entityId of the container entity
  @offset offset of the item in bag
  @treturn[1] nil if the entity doesn't exist or is not a container object or if the offset is out of range
  @treturn[2] item descriptor at given offset serialized to variant.
  */

  /***
  Removes up to amount items held in a Container Object at a specific offset if available. Returns the items taken.

  Note, this function is not guaranteed to give you the number of items you request.
  It will give you either every item in the slot, or the number you requested, whichever is less.

  @function containerTakeNumItemsAt
  @entityId entityId of the container entity
  @offset offset of the item in bag
  @amount maximum number of items to remove
  @treturn[1] nil if the entity doesn't exist or is not a container object or if the offset is out of range
  @treturn[2] item descriptor at given offset serialized to variant.
  */

  /***
  Returns the number of items from a given Variant serialized
  item that can fit in the given Container Object.
  This function does not modify the Container.

  @function containerItemsCanFit
  @entityId entityId of the container entity
  @items Variant serialized items to search with
  @treturn[1] nil if the entity doesn't exist or is not a container object
  @treturn[2] the number of items that can fit in this container
  */

  /***
  Returns a VariantMap indicating in which "slots" a given item stack will fit,
  and how many items would be "leftover" if you attempted to put the items in the container..
  This function does not modify the Container.

  @function containerItemsFitWhere
  @entityId entityId of the container entity
  @items Variant serialized items to search with
  @treturn[1] nil if the entity doesn't exist or is not a container object
  @treturn[2] a variant map containing a list of offsets under "slots" and a number under "leftover"
  */

  /***
  Adds the given items to a Container Object.  Returns any items unable to fit.
  Attempts to stack items first, then uses empty slots

  @function containerAddItems
  @entityId entityId of the container entity
  @items Variant serialized items to place
  @treturn[1] items if the entity doesn't exist or is not a container object
  @treturn[2] the items left over after inserting into the bag
  */

  /***
  Adds the given items to a Container Object.  Returns any items unable to fit.
  Attempts to stack items only, will not use empty slots

  @function containerStackItems
  @entityId entityId of the container entity
  @items Variant serialized items to place
  @treturn[1] items if the entity doesn't exist or is not a container object
  @treturn[2] the items left over after inserting into the bag
  */

  /***
  Puts the given items into a specific offset slot in the Container Object.  Returns any items unable to fit.

  @function containerPutItemsAt
  @entityId entityId of the container entity
  @items Variant serialized items to place
  @offset offset of the destination slot in bag
  @treturn[1] items if the entity doesn't exist or is not a container object or if the offset is out of range
  @treturn[2] the items left over after inserting into the given offset.
  */

  /***
  Put items in the container by combining with the specified slot,
  or swap the current items with the given items.

  @function containerSwapItems
  @entityId entityId of the container entity
  @items Variant serialized items to swap
  @offset offset of the destination slot in bag
  @treturn[1] items if the entity doesn't exist or is not a container object or if the offset is out of range
  @treturn[2] items leftover after the swap completes
  */

  /***
  Put items in the container by swapping the current items with the given items.
  Does not attempt to combine items

  @function containerSwapItemsNoCombine
  @entityId entityId of the container entity
  @items Variant serialized items to swap
  @offset offset of the destination slot in bag
  @treturn[1] items if the entity doesn't exist or is not a container object or if the offset is out of range
  @treturn[2] items leftover after the swap completes
  */

  /***
  Tries to apply the items to the item in the slot,
  returns the remainder of the applied item.

  @function containerItemApply
  @entityId entityId of the container entity
  @items Variant serialized items to apply
  @offset offset of the destination slot in bag
  @treturn[1] items if the entity doesn't exist or is not a container object or if the offset is out of range
  @treturn[2] items leftover after the application completes
  */

  /**
  Calls a lua function in the given entity's lua context.

  @function callScriptedEntity
  @entityId entityId The entity to call the function on. Must be an entity that
  can run scripts - e.g. a monster, npc, or (wire) object.
  @string name The name of the function to call. This does not need to be a
  global function - e.g. `entity.say` would call the "say" function on the
  `entity` table (as defined in the target entity's lua context).
  @param[opt] ... Arguments passed to function
  @treturn[1] nil if the entity does not exist, is not a scripted entity, or
  this function is being called from a tech script.
  @return[2] The result of calling the function.
  */

  /**
  Determine if a loungeable object is occupied.

  Note that loungeables may only be occupied by a humanoid (player or NPC).

  @function loungeableOccupied
  @entityId entityId the loungeable entity to check.
  @treturn[1] nil if the entity does not exist or is not a loungeable object
  @treturn[2] bool true if the entity is occupied or false if it is not
  */

  /***
  Determine if the given entity is a monster.

  @function isMonster
  @entityId entityId the entity to check
  @Bool[opt] isAggressive If given as true, will only return true if
  the entity is a monster and is marked as aggressive. If false is
  given, will only return true if the entity is not marked as
  aggressive.

  @treturn bool true if entity is a monster (and the aggressive flag was
  omitted, or matches the monster's aggressive flag); otherwise false
  */

  /***
  Determine if the given entity is an NPC.

  @function isNpc
  @entityId entityId the (int) entity ID of the entity to check
 @int[opt] damageTeam if given, the (int) damageTeam that a NPC entity must
  have for this function to return true.
  @treturn bool true if entity is an NPC and the damageTeam argument was
  omitted or matches the NPC's damage team. Otherwise false.
  */

  /***
  Mark the given item drop entity as taken.

  @function takeItemDrop
  @entityId entityId the item drop entity to take
  @entityId[opt] takenByEntityId the entity that is taking the item drop.
  If given, the item drop will animate towards this entity for a bit.
  @treturn[1] nil if the item was already taken, was not an item drop, or could
  not be taken for some other reason.
  @treturn[2] table descriptor of the item taken.
  */

  /// @Module worldEnvironment

  /***
  Gets the amount of light applied to a given position.

  @function lightLevel
  @position position the position to get the light level at
  @treturn number light level at the given position
  */

  /***
  Gets the amount of wind at the given position.

  @function windLevel
  @position position the position to get the wind level at
  @treturn number wind level at the given position
  */

  /***
  Gets the temperature at the given position.

  @function temperature
  @position position the position to get the temperature at
  @treturn number temperature at the given position
  */

  /***
  Gets whether or not the position is breathable.

  @function breathable
  @position position the position to check the breathability of
  @treturn bool true if the position is breathable, otherwise false.
  */

  /***
  Determine whether the given position is below the underground level.

  @function underground
  @position position the position to check
  @treturn bool true if the given position is below the underground level.
  */

  /***
  Gets the name of the material at the given position.

  @function material
  @position position the position to check
  @string layer The layer to check: "foreground" or "background"
  @treturn[1] nil if the chunk is not loaded yet
  @treturn[2] false if there is no material placed at the given position and layer.  true if there is, but it doesn't have a name.
  @treturn[3] string the material name, as defined in the `materialName` value
  of a *.material file.
  */

  /***
  Gets the tile modification on the tile at the given position.

  @function mod
  @position position the position to check
  @string layer the layer to check: "foreground" or "background"

  @treturn[1] nil if there is no tile modification placed at the given position and layer.
  @treturn[2] string the tile mod name, as defined in the `modName` value
  of a *.matmod file.
*/

  /***
  Applies damage to the tiles at the given positions.

  @function damageTiles
  @param positions List of { x, y } positions to damage tiles at
  @string layer The tile layer to damage: "foreground" or "background"
  @position sourcePosition The position of the cause of the damage
  @string type The type of damage to apply, allowed values are:
  "plantish", "blockish", "beamish", "explosive", "fire", "tilling"
  or "crushing". Note that "crushing" damage will prevent destroyed
  tiles from dropping a material item.
  @number amount The amount of damage to apply to each tile
  @treturn bool true if any tiles were actually damaged, false otherwise
  */

  /***
  Places a tile of a specific material at the given location.

  @function placeMaterial
  @position position The position to place the material at - fractional values
  will be ignored, placing at a tile position.
  @string layer The tile layer to place the tile on: "foreground" or "background"
  @string materialName The name of the material to place, as specified in the
  `materialName` value in a *.material file.
  @number[opt=nil] materialHue hue shift to apply to the material, if omitted
  (or nil), will default to whatever hue matches the biome in which it is placed
  @Bool[opt=false] allowOverlap If true, allows tiles to be placed even if they
  overlap entities at the same location.

  @treturn bool true if the material could be placed, false otherwise
  */

  /***
  Places a specific tile modification at the given location.

  @function placeMod
  @position position The position to place the mod at - fractional values
  will be ignored, placing at a tile position.
  @string layer The tile layer to place the mod on: "foreground" or "background"
  @string modName the tile mod name, as defined in the `modName` value
  of a *.matmod file.
  @number[opt=nil] modHue hue shift to apply to the mod, if omitted
  (or nil), will default to whatever hue matches the biome in which it is placed
  @Bool[opt=false] allowOverlap If true, allows tiles to be placed even if they
  overlap entities at the same location.

  @treturn bool true if the material could be placed, false otherwise
  */

  /// Entity callbacks query and mutate the specific entity that is running the
  /// lua script they are called from.
  ///
  /// These functions can be called from a _different_ entity by calling
  /// `@{world.callScriptedEntity}(targetEntityId, "entity.*")`, replacing the `\*`
  /// with the name of a function defined here.
  ///
  /// Specific types of entities (e.g. NPCs, Objects) define different sets of
  /// `entity.*` functions - if a function is only defined for a specific entity
  /// type, it will be indicated in the function's comment. Otherwise it should
  /// be assumed that the function is available to all scripted entity types.
  ///
  /// @Module entity

  /***
  Gets a numeric id that can be used to identify this specific entity.

  This id will be valid until the entity is unloaded. If you need a stable
  identifier, see @{world.entityUuid}.

  @function id
  @treturn entityId the id of the calling entity
  */

  /***
  Gets the entity's current world position.

  @function position
  @treturn vector world position of the entity
  */

  /***
  Gets the entity's damage team.

  Damage teams control which other entities can be damaged by this entity.

  @function damageTeam
  @treturn table map of `{ type = numeric, team = numeric }`
  */

  /***
  Gets the entity id of the closest valid target entity.

  Note that "valid target entities" are defined as entities that can be
  damaged (based on damage teams); and are players, NPCs, or aggressive
  monsters.

  @function closestValidTarget
  @number radius Maximum distance a valid target can be from this entity's position
  @treturn[1] entityId id of the closest valid target entity
  @treturn[2] entityId 0 if no valid target entity is in the given radius
  */

  /***
  Determines whether the given entity is a valid target of this entity.

  Note that "valid target entities" are defined as entities that can be
  damaged (based on damage teams); and are players, NPCs, or aggressive
  monsters

  @function isValidTarget
  @entityId entityId the id of the potential valid target entity
  @treturn bool true if the given entity is a valid target, false otherwise
  */

  /***
  Gets the vector from this entity's position to the given entity's position.

  Damage teams control which other entities can be damaged by this entity.

  @function distanceToEntity
  @entityId entityId entity to get a vector to
  @treturn[1] table { x, y } vector from this entity to the given entity
  @treturn[2] table { 0, 0 } if no entity exists with the given entity id
  */

  /***
  Determines if the given entity is in sight to this entity.

  Note that "in sight" is defined as not having solid collision
  intersecting the line between the entities' positions

  @function entityInSight
  @entityId entityId the entity check for line of sight on
  @treturn bool true if the entity is in sight, false otherwise
  */

  /***
  Gets the current health of this entity.

  Available to: monsters, npcs.

  @function health
  @treturn double current health value
  */

  /***
  Gets the maximum health of this entity.

  Available to: monsters, npcs.

  @function maxHealth
  @treturn double maximum possible health value
  */

  /***
  Gets the value of a configuration option for this entity.

  Available to: monsters, npcs, objects.

  @function configParameter
  @string name the name of the configuration value to get, as specified in the
  entity's configuration (e.g. *.monstertype for monsters)
  @param[opt] default a default value that will be returned if the given
  configuration key does not exist in the entity's configuration.
  @treturn[1] nil if the entity has no configuration option with the given name,
  and no default value is given.
  @return[2] the value of the configuration option, or the given default value.
  */

  /***
  Gets a random value from a list in the entity's configuration.

  Available to: monsters, npcs, objects.

  @function randomizeParameter
  @string name the name of the configuration value to get, as specified in the
  entity's configuration file (e.g. *.monstertype for monsters)
  @param[opt] default a default list to pick a value from, if the configuration
  option is not found for this entity.
  @treturn[1] nil if the entity has no configuration option with the given name,
  and no default list is given, or if the selected list is empty.
  @return[2] a randomly selected value from the configuration option list
  */

  /***
  Gets a stable random value from a list in the entity's configuration.

  Unlike @{randomizeParameter}, the returned value will always be the same when
  called from the same entity (or another entity with the same seed).

  Available to: monsters, npcs, objects.

  @function staticRandomizeParameter
  @string name the name of the configuration value to get, as specified in the
  entity's configuration file (e.g. *.monstertype for monsters)
  @param[opt] default a default list to pick a value from if the configuration
  option is not found for this entity.
  @treturn[1] nil if the entity has no configuration option with the given name,
  and no default list is given, or if the selected list is empty.
  @return[2] a randomly selected value from the configuration option list
  */

  /***
  Gets a random value between two numbers specified in the entity's configuration.

  Range endpoints are inclusive. Ranges should be specified in configuration
  files as two-component arrays, e.g. `[1.2, 3.4]`

  Available to: monsters, npcs, objects.

  @function randomizeParameterRange
  @string name the name of the configuration value to get, as specified in the
  entity's configuration file (e.g. *.monstertype for monsters)
  @param[opt] default a default range to pick a value from if the configuration
  option is not found for this entity.
  @treturn[1] nil if the entity has no configuration option with the given name,
  and no default list is given, or if the selected list is empty.
  @return[2] a randomly selected value from the configuration option list
  */