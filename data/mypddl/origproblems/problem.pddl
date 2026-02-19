(define (problem taskplan)
  (:domain D1)

  (:objects
    p1 p2 p3 p4 - T1

    s1 s2 s3 s4 - T5

    p1b1 p1b2 p1b3
    p2b1 p2b2 p2b3
    p3b1 p3b2 p3b3
    p4b1 p4b2 p4b3 - T4

    t1a t1b t2a t2b t3a t3b t4a t4b - T10

    u1a u1b u2a u2b u3a u3b u4a u4b - T14
    v1a v1b v2a v2b v3a v3b v4a v4b - T15

    m1 - T6
    g1 - T7
    e1 - T8

    res16 - T16
    res18 - T18
    res19 - T19

    d17a d17b - T17
    extra7 - T7
    extra6 - T6
    extra8 - T8
  )

  (:init
    (R1 p1) (R1 p2) (R1 p3) (R1 p4)

    (R42 p1) (R43 p1) (R30 p1) (R41 p1) (R28 p1) (R29 p1)
    (R42 p2) (R43 p2) (R30 p2) (R41 p2) (R28 p2) (R29 p2)
    (R42 p3) (R43 p3) (R30 p3) (R41 p3) (R28 p3) (R29 p3)
    (R42 p4) (R43 p4) (R30 p4) (R41 p4) (R28 p4) (R29 p4)

    
    (R13 p1 u1a) (R13 p1 u1b) (R13 p1 v1a) (R13 p1 v1b)
    (R36 u1a) (R36 u1b) (R36 v1a) (R36 v1b)
    (R31 u1a) (R32 u1a) (R31 u1b) (R32 u1b)

    (R13 p2 u2a) (R13 p2 u2b) (R13 p2 v2a) (R13 p2 v2b)
    (R36 u2a) (R36 u2b) (R36 v2a) (R36 v2b)
    (R31 u2a) (R32 u2a) (R31 u2b) (R32 u2b)

    
    (R13 p3 u3a) (R13 p3 u3b) (R13 p3 v3a) (R13 p3 v3b)
    (R36 u3a) (R36 u3b) (R36 v3a) (R36 v3b)
    (R31 u3a) (R32 u3a) (R31 u3b) (R32 u3b)

    
    (R13 p4 u4a) (R13 p4 u4b) (R13 p4 v4a) (R13 p4 v4b)
    (R36 u4a) (R36 u4b) (R36 v4a) (R36 v4b)
    (R31 u4a) (R32 u4a) (R31 u4b) (R32 u4b)

    
    (R47 p1b1) (R47 p1b2) (R47 p1b3)
    (R47 p2b1) (R47 p2b2) (R47 p2b3)
    (R47 p3b1) (R47 p3b2) (R47 p3b3)
    (R47 p4b1) (R47 p4b2) (R47 p4b3)

    
    (R9 p1b1) (R9 p1b2) (R9 p1b3) (R10 p1b1) (R10 p1b2) (R10 p1b3)
    (R9 p2b1) (R9 p2b2) (R9 p2b3) (R10 p2b1) (R10 p2b2) (R10 p2b3)
    (R9 p3b1) (R9 p3b2) (R9 p3b3) (R10 p3b1) (R10 p3b2) (R10 p3b3)
    (R9 p4b1) (R9 p4b2) (R9 p4b3) (R10 p4b1) (R10 p4b2) (R10 p4b3)

    (R46 p1 p1b1) (R46 p1 p1b2) (R46 p1 p1b3)
    (R46 p2 p2b1) (R46 p2 p2b2) (R46 p2 p2b3)
    (R46 p3 p3b1) (R46 p3 p3b2) (R46 p3 p3b3)
    (R46 p4 p4b1) (R46 p4 p4b2) (R46 p4 p4b3)

    (R71 res16)
    (R71 res18)
    (R71 res19)
  )

  (:goal
    (and
      (R3 p1)
      (R3 p2)
      (R3 p3)
      (R3 p4)
    )
  )
)
