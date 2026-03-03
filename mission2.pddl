(define (problem lunar-mission-1)
    (:domain lunar)

;define the objects
    (:objects
        r - rover
        ld - lander
        wp1 wp2 wp3 wp4 wp5 - location
        s - sample
        i - image
        sc - scan
    )

;list the initial conditions
    (:init
        (at_lander r ld)
        (lander_at ld wp5)




        (connected wp1 wp2)
        (connected wp2 wp3)
        (connected wp1 wp4)
        (connected wp4 wp3)
        (connected wp3 wp5)
        (connected wp5 wp1)


        (sample_location s wp1)
        (image_location i wp5)
        (scan_location sc wp3)


        (assigned_image r i)
        (assigned_scan r sc)
        (assigned_sample r s)
        (assigned_lander r ld)


        (storage_free ld)
    )

;state the goal
    (:goal
        (and
            (image_taken r i wp5)
            (scan_taken r sc wp3)
            (image_transmitted r i ld)
            (scan_transmitted r sc ld)
            (sample_collected r s wp1)
            (not (storage_free ld))
        )
    )
)
