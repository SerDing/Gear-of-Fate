# Combat System for Gof

## 1.Action

    Finite State Machine

## 2.Animation

    frame-based animation, attack box, damage box

## 3.Collision Detection For Attack

    2DRectangle, AABB

    collisionCachePool: use to cache objects that have been collided to avoid duplicate collision
    collisionCachePool = {
        [stateName] = {
            [objectTag] = collisionTimes
        }
    }


## 4.Movement

