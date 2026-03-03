(define (problem lunar-mission-2)
    (:domain lunar)

;define the objects
    (:objects
        r1 r2 - rover
        ld1 ld2 - lander
        wp1 wp2 wp3 wp4 wp5 wp6 - location
        s1 s2 - sample
        i1 i2 - image
        sc1 sc2 - scan
       
    )

;list the initial conditions
    (:init
        (deployed r1)
        (at r1 wp2)
        (at_lander r2 ld2)
        (lander_at ld1 wp2)
        (lander_at ld2 wp5)
        (connected wp1 wp2)
        (connected wp2 wp1)
        (connected wp6 wp4)
        (connected wp4 wp2)
        (connected wp2 wp3)
        (connected wp3 wp5)
        (connected wp5 wp6)
        (connected wp5 wp3)
        (connected wp2 wp4)
        (image_location i1 wp3)
        (scan_location sc1 wp4)
        (image_location i2 wp2)
        (scan_location sc2 wp6)
        (sample_location s1 wp5)
        (sample_location s2 wp1)
        (storage_free ld1)
        (storage_free ld2)
        (memory_free r1)
        (memory_free r2)
        (assigned_image r2 i1)
        (assigned_scan r2 sc1)
        (assigned_image r1 i2)
        (assigned_scan r2 sc2)
        (assigned_sample r2 s1)
        (assigned_sample r1 s2)
        (assigned_lander r2 ld2)
        (assigned_lander r1 ld1)


       
    )

;state the goal
    (:goal
        (and
            (image_taken r2 i1 wp3)
            (scan_taken r2 sc1 wp4)
            (image_transmitted r2 i1 ld2)
            (scan_transmitted r2 sc1 ld2)
            (image_taken r1 i2 wp2)
            (scan_taken r2 sc2 wp6)
            (image_transmitted r1 i2 ld1)
            (scan_transmitted r2 sc2 ld2)
            (sample_collected r2 s1 wp5)
            (sample_collected r1 s2 wp1)
            (not (storage_free ld1))
            (not (storage_free ld2))


           
        )
    )
)
