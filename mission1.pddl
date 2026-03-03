(define (domain lunar)
    (:requirements :strips :typing :negative-preconditions)
;define objects types
    (:types
        rover lander image scan sample location - object
    )
;list predicates that would be used
    (:predicates
        ;rover and lander location
        (at ?r - rover ?l - location)
        (at_lander ?r - rover ?ld - lander)
        (lander_at ?ld - lander ?l - location)
        (deployed ?r - rover)
        (connected ?l1 - location ?l2 - location)

        ;memory and storage
        (memory_free ?r - rover)
        (storage_free ?ld - lander)

        ;location of images, scans and samples
        (image_location ?i - image ?l - location)
        (scan_location ?sc - scan ?l - location)
        (sample_location ?s - sample ?l - location)

        ;actions performed by rover
        (scan_taken ?r - rover ?sc - scan ?l - location)
        (image_taken ?r - rover ?i - image ?l - location)
        (sample_collected ?r - rover ?s - sample ?l - location)
        (carrying_sample ?r - rover ?s - sample)
        (carrying_scan ?r - rover ?sc - scan)
        (carrying_image ?r - rover ?i - image)
        (image_transmitted ?r - rover ?i - image ?ld - lander)
        (scan_transmitted ?r - rover ?sc - scan ?ld - lander)

        ;assign tasks to rover
        (assigned_image ?r - rover ?i - image)
        (assigned_scan ?r - rover ?sc - scan)
        (assigned_sample ?r - rover ?s - sample)
        (assigned_lander ?r - rover ?ld - lander)
    )
;list actions that performed by rover, and also parameters, preconditions and effects involved in each action
    (:action deploy-rover
        :parameters (?r - rover ?ld - lander ?l - location)
        :precondition (and
            (lander_at ?ld ?l)
            (at_lander ?r ?ld)
            (not (deployed ?r))
        )
        :effect (and
            (deployed ?r)
            (at ?r ?l)
            (not (at_lander ?r ?ld))
            (memory_free ?r)
        )
    )

    (:action move
        :parameters (?r - rover ?from - location ?to - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?from)
            (connected ?from ?to)
        )
        :effect (and
            (not (at ?r ?from))
            (at ?r ?to)
        )
    )

    (:action collect-sample
        :parameters (?r - rover ?s - sample ?l - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?l)
            (sample_location ?s ?l)
            (assigned_sample ?r ?s)
            (not (carrying_sample ?r ?s))
            (not (sample_collected ?r ?s ?l))
        )
        :effect (and
            (sample_collected ?r ?s ?l)
            (carrying_sample ?r ?s)
            (not (sample_location ?s ?l)))
    )

    (:action store-sample
        :parameters (?r - rover ?s - sample ?ld - lander ?l - location)
        :precondition (and
            (deployed ?r)
            (carrying_sample ?r ?s)
            (at ?r ?l)
            (lander_at ?ld ?l)
            (storage_free ?ld)
            (assigned_lander ?r ?ld)
        )
        :effect (and
            (at_lander ?r ?ld)
            (not (carrying_sample ?r ?s))
            (not (storage_free ?ld))
        )
    )

    (:action take-image
        :parameters (?r - rover ?i - image ?l - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?l)
            (memory_free ?r)
            (image_location ?i ?l)
            (assigned_image ?r ?i)
            (not (image_taken ?r ?i ?l))
        )
        :effect (and
            (carrying_image ?r ?i)
            (image_taken ?r ?i ?l)
            (not (memory_free ?r))
        )
    )

    (:action scan
        :parameters (?r - rover ?sc - scan ?l - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?l)
            (memory_free ?r)
            (scan_location ?sc ?l)
            (assigned_scan ?r ?sc)
            (not (scan_taken ?r ?sc ?l))
        )
        :effect (and
            (carrying_scan ?r ?sc)
            (scan_taken ?r ?sc ?l)
            (not (memory_free ?r))
        )
    )

    (:action transmit-image
        :parameters (?r - rover ?i - image ?ld - lander ?l - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?l)
            (carrying_image ?r ?i)
            (not (image_transmitted ?r ?i ?ld))
            (assigned_lander ?r ?ld)
        )
        :effect (and
            (image_transmitted ?r ?i ?ld)
            (memory_free ?r)
            (not (carrying_image ?r ?i))
        )
    )

    (:action transmit-scan
        :parameters (?r - rover ?sc - scan ?ld - lander ?l - location)
        :precondition (and
            (deployed ?r)
            (at ?r ?l)
            (carrying_scan ?r ?sc)
            (not (scan_transmitted ?r ?sc ?ld))
            (assigned_lander ?r ?ld)
        )
        :effect (and
            (scan_transmitted ?r ?sc ?ld)
            (memory_free ?r)
            (not (carrying_scan ?r ?sc))
        )
    )


)