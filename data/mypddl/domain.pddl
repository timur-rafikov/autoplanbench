(define (domain D1)
(:requirements :strips :typing :negative-preconditions :equality)

  (:types
    T12 - object
    T1 T2 T3 T4 T5 T6 T7 T8 T9 T10 T11 - T12
    T13 - T1
    T14 T15 - T2
    T16 T17 T18 T19 - T11
  )

  (:predicates

    (R76 ?V12 - T8)
    (R40 ?V1 - T1)


    (R120 ?V1 - T1)
    (R59 ?V9 - T5)


    (R49 ?V9 - T5)
    (R25 ?V8 - T3)


    (R71 ?V11 - T11)
    (R81 ?V3 - T7)
    (R28 ?V1 - T1)
    (R36 ?V7 - T2)

    (R89 ?V10 - T10)

    (R17 ?V8 - T3 ?V7 - T2)
    (R129 ?V4 - T4 ?V10 - T10)

  (R10 ?V4 - T4)




    (R51 ?V9 - T5 ?V7 - T14)
    (R119 ?V1 - T1)
    (R46 ?V1 - T1 ?V4 - T4)
    (R54 ?V9 - T5 ?V7 - T14)
    (R68 ?V2 - T6)
    (R27 ?V1 - T1)
    (R106 ?V2 - T6)
    (R20 ?V8 - T3)
    (R3 ?V1 - T1)
    (R99 ?V1 - T1)

    (R117 ?V9 - T5)
    (R77 ?V12 - T8 ?V3 - T7)
    (R47 ?V4 - T4)

    (R111 ?V1 - T1 ?V7 - T2)

    (R64 ?V1 - T1)
    (R107 ?V2 - T6)

    (R9 ?V4 - T4)
    (R126 ?V1 - T1)
    (R14 ?V1 - T1 ?V7 - T2)


    (R88 ?V1 - T1 ?V10 - T10)
    (R92 ?V9 - T5)
    (R127 ?V1 - T1)

    (R5 ?V1 - T1)
    (R63 ?V1 - T1)
    (R85 ?V1 - T1 ?V5 - T9)
    (R53 ?V9 - T5)
    (R56 ?V9 - T5)
    (R102 ?V12 - T8)
    (R73 ?V2 - T6)


    (R42 ?V1 - T1)
    (R21 ?V8 - T3)
    (R78 ?V12 - T8)
    (R4 ?V1 - T1)
    (R44 ?V1 - T1)
    (R48 ?V9 - T5 ?V1 - T1)
    (R94 ?V9 - T5)
    (R30 ?V1 - T1)


    (R123 ?V9 - T5)

    (R18 ?V8 - T3)
    (R6 ?V1 - T1)
    (R109 ?V7 - T2)
    (R82 ?V3 - T7)


    (R29 ?V1 - T1)
    (R86 ?V5 - T9)
    (R45 ?V1 - T1)


    (R87 ?V1 - T1)
    (R115 ?V1 - T1)

    (R8 ?V3 - T7)
    (R72 ?V11 - T11)
    (R35 ?V7 - T2)
    (R108 ?V7 - T2)
    (R37 ?V1 - T1)
    (R96 ?V1 - T1)
    (R98 ?V1 - T1)
    (R93 ?V9 - T5)
    (R12 ?V1 - T1 ?V6 - T4)


    (R114 ?V1 - T1 ?V11 - T11)
    (R128 ?V4 - T4)
    (R79 ?V12 - T8)
    (R34 ?V7 - T2)
    (R11 ?V1 - T1 ?V5 - T9)
    (R43 ?V1 - T1)
    (R61 ?V1 - T1 ?V2 - T6)
    (R97 ?V1 - T1)

    (R83 ?V1 - T1)


    (R55 ?V9 - T5)
    (R66 ?V2 - T6)
    (R74 ?V3 - T7 ?V1 - T1 ?V7 - T14)
    (R1 ?V1 - T1)
    (R26 ?V1 - T1)
    (R125 ?V10 - T10)

    (R58 ?V1 - T1)

    (R122 ?V9 - T5 ?V25 - T14)
    (R100 ?V3 - T7)
    (R84 ?V1 - T1)


    
    (R118 ?V9 - T5)

    (R80 ?V12 - T8)
    (R22 ?V8 - T3)
    (R50 ?V9 - T5 ?V4 - T4)
    (R31 ?V7 - T2)
    (R70 ?V2 - T6)


    (R90 ?V9 - T5 ?V10 - T10)
    (R24 ?V8 - T3)
    (R104 ?V3 - T7 ?V12 - T8)

    (R23 ?V8 - T3)
    (R101 ?V3 - T7)

    (R65 ?V1 - T1)
    (R19 ?V8 - T3)


    (R62 ?V2 - T6)
    (R91 ?V9 - T5)
    (R121 ?V1 - T1)

    (R38 ?V1 - T1)
    (R7 ?V2 - T6)
    (R57 ?V9 - T5)
    (R116 ?V1 - T1)
    (R13 ?V1 - T1 ?V7 - T2)
    (R39 ?V1 - T1)


    (R105 ?V1 - T1 ?V2 - T6)
    (R32 ?V7 - T2)
    (R69 ?V2 - T6)
    (R16 ?V8 - T3 ?V1 - T1)
    (R113 ?V11 - T11)
    (R112 ?V11 - T11)
    (R15 ?V1 - T1 ?V8 - T3)
    (R60 ?V1 - T1)
    (R41 ?V1 - T1)


    (R2 ?V1 - T1)
    (R67 ?V2 - T6)
    (R103 ?V12 - T8)
    (R52 ?V9 - T5 ?V10 - T10)

    (R124 ?V3 - T7 ?V10 - T10)
    (R110 ?V1 - T1 ?V7 - T2)
    (R75 ?V3 - T7)
    (R95 ?V9 - T5 ?V4 - T4)

    (R33 ?V7 - T2)


    )






  (:action A57
    :parameters (?V1 - T1 ?V2 - T6 ?V3 - T7)
    :precondition (and (R2 ?V1)
                       (R84 ?V1)
                       (R62 ?V2)
                       (R68 ?V2)
                       (R69 ?V2)
                       (R82 ?V3)
                       (not (R3 ?V1)))
    :effect (and (R3 ?V1) (not (R2 ?V1)))
  )

  (:action A58
    :parameters (?V1 - T1 ?V5 - T9)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R11 ?V1 ?V5)
                       (not (R85 ?V1 ?V5))
                       (not (R87 ?V1)))
    :effect (R85 ?V1 ?V5)
  )

  (:action A26
    :parameters (?V9 - T5)
    :precondition (and (R49 ?V9)
                       (not (R57 ?V9))
                       (not (R53 ?V9)))
    :effect (R53 ?V9)
  )

  (:action A42
    :parameters (?V2 - T6 ?V30 - T18)
    :precondition (and (R68 ?V2)
                       (R71 ?V30)
                       (not (R73 ?V2)))
    :effect (and (R73 ?V2)
                 (R72 ?V30) (not (R71 ?V30)))
  )

  (:action A1
    :parameters (?V1 - T1)
    :precondition (and (not (R1 ?V1)) (not (R3 ?V1)) (not (R4 ?V1)))
    :effect (R1 ?V1)
  )

  (:action A30
    :parameters (?V9 - T5)
    :precondition (and (R56 ?V9)
                       (not (R57 ?V9)))
    :effect (and (R57 ?V9) (not (R53 ?V9)))
  )

  (:action A17
  :parameters (?V1 - T1
               ?V16 - T14 ?V17 - T14 ?V14 - T15 ?V15 - T15
               ?V18 - T3 ?V19 - T3 ?V20 - T3 ?V21 - T3 ?V22 - T3)
  :precondition (and (R1 ?V1) (not (R2 ?V1))
                     (R26 ?V1) (R28 ?V1) (R27 ?V1) (R29 ?V1)
                     (R16 ?V18 ?V1) (R20 ?V18) (R19 ?V18)
                     (R16 ?V19 ?V1) (R22 ?V19) (R19 ?V19)
                     (R16 ?V20 ?V1) (R21 ?V20) (R19 ?V20)
                     (R16 ?V21 ?V1) (R24 ?V21) (R19 ?V21)
                     (R16 ?V22 ?V1) (R23 ?V22) (R19 ?V22)
                     (R13 ?V1 ?V16) (R13 ?V1 ?V17) (R13 ?V1 ?V14) (R13 ?V1 ?V15)
                     (R36 ?V16) (R36 ?V17) (R36 ?V14) (R36 ?V15)
                     (R39 ?V1)
                     (not (R41 ?V1))
                     (not (= ?V16 ?V17))
                     (not (= ?V14 ?V15)))
  :effect (R41 ?V1)
)

  (:action A13
    :parameters (?V1 - T1 ?V7 - T2)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R14 ?V1 ?V7)
                       (R31 ?V7)
                       (not (R34 ?V7)))
    :effect (R34 ?V7)
  )

  (:action A64
    :parameters (?V1 - T1 ?V29 - T17)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R71 ?V29)
                       (not (R114 ?V1 ?V29))
                       (not (R115 ?V1))
                       (not (R4 ?V1)))
    :effect (and (R114 ?V1 ?V29)
                 (R72 ?V29) (not (R71 ?V29)))
  )

  (:action A60
    :parameters (?V1 - T1 ?V5 - T9)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R85 ?V1 ?V5)
                       (not (R86 ?V5))
                       (not (R87 ?V1)))
    :effect (R87 ?V1)
  )

  (:action A24
    :parameters (?V1 - T1 ?V9 - T5 ?V4 - T4)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R48 ?V9 ?V1)
                       (R49 ?V9)
                       (R47 ?V4)
                       (not (R57 ?V9))
                       (not (R50 ?V9 ?V4)))
    :effect (R50 ?V9 ?V4)
  )

  (:action A38
    :parameters (?V1 - T1)
    :precondition (and (R2 ?V1)
                       (R64 ?V1)
                       (not (R65 ?V1)))
    :effect (R65 ?V1)
  )

  (:action A41
  :parameters (?V2 - T6 ?V1 - T1 ?V9 - T5 ?V4 - T4)
  :precondition (and (R2 ?V1)
                     (R45 ?V1)
                     (R43 ?V1)
                     (R67 ?V2)
                     (R48 ?V9 ?V1) (R57 ?V9)

                     (R50 ?V9 ?V4)
                     (R46 ?V1 ?V4)


                     (R9 ?V4)

                     (R28 ?V1) (R29 ?V1)
                     (not (R68 ?V2)))
  :effect (R68 ?V2)
)

  (:action A35
    :parameters (?V1 - T1 ?V2 - T6)
    :precondition (and (R1 ?V1) (not (R2 ?V1)) (not (R45 ?V1))
                       (not (R4 ?V1)))
    :effect (and (R61 ?V1 ?V2)
                 (R6 ?V1)
                 (R4 ?V1))
  )

  (:action A74
    :parameters (?V1 - T1)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R42 ?V1)
                       (not (R98 ?V1))
                       (not (R127 ?V1)))
    :effect (and (R98 ?V1)
                 (R127 ?V1))
  )

  (:action A39
    :parameters (?V2 - T6 ?V1 - T1)
    :precondition (and (R2 ?V1)
                       (R62 ?V2)
                       (R65 ?V1)
                       (not (R66 ?V2)))
    :effect (R66 ?V2)
  )

  (:action A71
    :parameters (?V9 - T5)
    :precondition (and (R91 ?V9)
                       (not (R93 ?V9)))
    :effect (and (R93 ?V9)
                 (R94 ?V9)
                 (not (R91 ?V9)))
  )

  (:action A5
    :parameters (?V1 - T1 ?V8 - T3)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R15 ?V1 ?V8) (R16 ?V8 ?V1)
                       (R18 ?V8) (R21 ?V8)
                       (not (R19 ?V8)))
    :effect (and (R19 ?V8) (R27 ?V1))
  )

  (:action A62
    :parameters (?V1 - T1 ?V5 - T9 ?V10 - T10)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R85 ?V1 ?V5)
                       (R86 ?V5)
                       (R88 ?V1 ?V10)
                       (R89 ?V10)
                       (not (R87 ?V1))
                       (not (R96 ?V1))
                       (not (R99 ?V1)))
    :effect (R96 ?V1)
  )

  (:action A82
    :parameters (?V3 - T7 ?V1 - T1 ?V2 - T6 ?V25 - T14)
    :precondition (and (R2 ?V1)
                       (R74 ?V3 ?V1 ?V25)
                       (R8 ?V3)
                       (R70 ?V2)
                       (R106 ?V2)
                       (R100 ?V3)
                       (not (R107 ?V2))
                       (not (R82 ?V3)))
    :effect (and (R82 ?V3)
                 (R107 ?V2))
  )

  (:action A14
    :parameters (?V1 - T1 ?V7 - T2)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R14 ?V1 ?V7)
                       (R31 ?V7)
                       (not (R35 ?V7)))
    :effect (R35 ?V7)
  )

  (:action A4
    :parameters (?V1 - T1 ?V8 - T3)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R15 ?V1 ?V8) (R16 ?V8 ?V1)
                       (R18 ?V8) (R20 ?V8)
                       (not (R19 ?V8)))
    :effect (and (R19 ?V8) (R26 ?V1))
  )

  (:action A15
    :parameters (?V1 - T1)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R26 ?V1)
                       (not (R39 ?V1)))
    :effect (and (R37 ?V1)
                 (R38 ?V1)
                 (R39 ?V1))
  )

  (:action A19
    :parameters (?V1 - T1)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R40 ?V1)
                       (R26 ?V1) (R28 ?V1)
                       (not (R42 ?V1)))
    :effect (and (R42 ?V1) (R44 ?V1))
  )

  (:action A10
    :parameters (?V1 - T1 ?V7 - T2 ?V8 - T3)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R15 ?V1 ?V8) (R17 ?V8 ?V7)
                       (R18 ?V8) (R25 ?V8)
                       (not (R19 ?V8)))
    :effect (and (R19 ?V8) (R31 ?V7))
  )

  (:action A85
    :parameters (?V7 - T2)
    :precondition (and (R108 ?V7)
                       (not (R109 ?V7)))
    :effect (R109 ?V7)
  )

  (:action A25
    :parameters (?V1 - T1 ?V9 - T5 ?V25 - T14 ?V10 - T10)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R48 ?V9 ?V1)
                       (R49 ?V9)
                       (R13 ?V1 ?V25)
                       (R31 ?V25) (R32 ?V25)
                       (R52 ?V9 ?V10)
                       (not (R51 ?V9 ?V25)))
    :effect (and (R51 ?V9 ?V25)
                 (not (R52 ?V9 ?V10)))
  )

  (:action A88
    :parameters (?V11 - T11)
    :precondition (and (R71 ?V11)
                       (not (R112 ?V11))
                       (not (R72 ?V11)))
    :effect (and (R112 ?V11)
                 (not (R71 ?V11)))
  )

  (:action A69
    :parameters (?V1 - T1 ?V9 - T5 ?V4 - T4)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R48 ?V9 ?V1)
                       (R49 ?V9)
                       (R91 ?V9)
                       (R50 ?V9 ?V4)
                       (not (R95 ?V9 ?V4))
                       (not (R94 ?V9)))
    :effect (and (R95 ?V9 ?V4)
                 (R117 ?V9))
  )

  (:action A48
  :parameters (?V3 - T7)
  :precondition (and (R8 ?V3)
                     (not (R75 ?V3)))
  :effect (R75 ?V3)
)

  (:action A43
    :parameters (?V1 - T1 ?V30 - T18)
    :precondition (and (R2 ?V1) (R71 ?V30) (not (R4 ?V1)))
    :effect (and (R72 ?V30) (not (R71 ?V30)))
  )

  (:action A44
    :parameters (?V2 - T6)
    :precondition (and (R73 ?V2)
                       (not (R69 ?V2))
                       (not (R7 ?V2)))
    :effect (R7 ?V2)
  )

  (:action A33
    :parameters (?V1 - T1 ?V9 - T5)
    :precondition (and (R1 ?V1)
                       (R58 ?V1)
                       (R48 ?V9 ?V1) (R57 ?V9)
                       (R45 ?V1)
                       (not (R2 ?V1))
                       (not (R4 ?V1)))
    :effect (and (R2 ?V1) (not (R1 ?V1)))
  )

  (:action A51
    :parameters (?V1 - T1 ?V32 - T16)
    :precondition (and (R2 ?V1) (R71 ?V32) (not (R83 ?V1)))
    :effect (and (R83 ?V1)
                 (R72 ?V32) (not (R71 ?V32)))
  )

  (:action A75
    :parameters (?V2 - T6)
    :precondition (and (R62 ?V2)
                       (not (R106 ?V2))
                       (not (R107 ?V2)))
    :effect (R106 ?V2)
  )

  (:action A86
    :parameters (?V1 - T1 ?V7 - T2)
    :precondition (and (R2 ?V1)
                       (R31 ?V7)
                       (R108 ?V7)
                       (not (R109 ?V7))
                       (not (R110 ?V1 ?V7)))
    :effect (R110 ?V1 ?V7)
  )

  (:action A56
  :parameters (?V1 - T1 ?V16 - T14 ?V17 - T14 ?V14 - T15 ?V15 - T15 ?V2 - T6 ?V3 - T7)
  :precondition (and
                  (R2 ?V1)
                  (R45 ?V1) (R43 ?V1)
                  (R41 ?V1)
                  (R30 ?V1)

                  (R13 ?V1 ?V16) (R13 ?V1 ?V17) (R13 ?V1 ?V14) (R13 ?V1 ?V15)
                  (R36 ?V16) (R36 ?V17) (R36 ?V14) (R36 ?V15)


                  (not (= ?V16 ?V17))
                  (not (= ?V14 ?V15))

                  (R70 ?V2)
                  (R82 ?V3)

                  (not (R5 ?V1))
                  (not (R6 ?V1))
                  (not (R4 ?V1))
                  (not (R84 ?V1)))
  :effect (R84 ?V1)
)

  (:action A7
    :parameters (?V1 - T1 ?V8 - T3)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R15 ?V1 ?V8) (R16 ?V8 ?V1)
                       (R18 ?V8) (R24 ?V8)
                       (not (R19 ?V8)))
    :effect (and (R19 ?V8) (R29 ?V1))
  )

  (:action A81
    :parameters (?V3 - T7 ?V12 - T8)
    :precondition (and (R104 ?V3 ?V12)
                       (not (R100 ?V3))
                       (not (R101 ?V3)))
    :effect (R101 ?V3)
  )

  (:action A6
    :parameters (?V1 - T1 ?V8 - T3)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R15 ?V1 ?V8) (R16 ?V8 ?V1)
                       (R18 ?V8) (R22 ?V8)
                       (not (R19 ?V8)))
    :effect (and (R19 ?V8) (R28 ?V1))
  )

  (:action A83
    :parameters (?V1 - T1 ?V2 - T6)
    :precondition (and (R2 ?V1)
                       (R62 ?V2)
                       (R68 ?V2)
                       (not (R105 ?V1 ?V2)))
    :effect (R105 ?V1 ?V2)
  )

  (:action A68
    :parameters (?V9 - T5 ?V10 - T10)
    :precondition (and (R49 ?V9)
                       (R90 ?V9 ?V10)
                       (not (R91 ?V9))
                       (not (R92 ?V9)))
    :effect (and (R91 ?V9)
                 (R92 ?V9)
                 (not (R90 ?V9 ?V10)))
  )

  (:action A21
    :parameters (?V1 - T1)
    :precondition (and (R1 ?V1) (not (R2 ?V1)) (not (R5 ?V1)))
    :effect (R5 ?V1)
  )

  (:action A52
    :parameters (?V12 - T8)
    :precondition (and (R78 ?V12)
                       (not (R79 ?V12)))
    :effect (R79 ?V12)
  )

  (:action A55
  :parameters (?V3 - T7 ?V2 - T6 ?V1 - T1 ?V12 - T8 ?V25 - T14)
  :precondition (and
                 (R2 ?V1)
                 (not (R4 ?V1))


                 (R74 ?V3 ?V1 ?V25)
                 (R8 ?V3)


                 (R61 ?V1 ?V2)
                 (R62 ?V2)


                 (R77 ?V12 ?V3)
                 (R80 ?V12)

                 (R81 ?V3)
                 (not (R82 ?V3)))
  :effect (R82 ?V3)
)

  (:action A2
    :parameters (?V1 - T1 ?V5 - T9)
    :precondition (and (R1 ?V1) (not (R2 ?V1)) (not (R4 ?V1)))
    :effect (R11 ?V1 ?V5)
  )

  (:action A54
    :parameters (?V3 - T7)
    :precondition (and (not (R81 ?V3)))
    :effect (R81 ?V3)
  )

  (:action A22
    :parameters (?V1 - T1 ?V4 - T4)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R46 ?V1 ?V4)
                       (R45 ?V1)
                       (not (R47 ?V4)))
    :effect (R47 ?V4)
  )

  (:action A66
    :parameters (?V1 - T1 ?V29 - T17)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R114 ?V1 ?V29)
                       (not (R113 ?V29))
                       (not (R99 ?V1)))
    :effect (and (R113 ?V29)
                 (R99 ?V1)
                 (not (R114 ?V1 ?V29)))
  )

  (:action A32
    :parameters (?V1 - T1 ?V9 - T5 ?V29 - T17 ?V23 - T10 ?V24 - T10)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R48 ?V9 ?V1)
                       (R49 ?V9)
                       (R71 ?V29)
                       (not (R59 ?V9)))
    :effect (and (R59 ?V9)
                 (R72 ?V29)
                 (not (R71 ?V29))
                 (not (R57 ?V9))
                 (not (R56 ?V9))
                 (not (R55 ?V9))
                 (not (R53 ?V9))
                 (R52 ?V9 ?V23)
                 (R52 ?V9 ?V24))
  )

  (:action A65
    :parameters (?V1 - T1 ?V9 - T5 ?V29 - T17)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R48 ?V9 ?V1)
                       (R49 ?V9)
                       (R114 ?V1 ?V29)
                       (not (R57 ?V9))
                       (not (R94 ?V9)))
    :effect (and (R57 ?V9)
                 (R91 ?V9)
                 (R115 ?V1)
                 (not (R114 ?V1 ?V29)))
  )

  (:action A73
    :parameters (?V1 - T1 ?V5 - T9)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R44 ?V1)
                       (R85 ?V1 ?V5)
                       (R86 ?V5)
                       (not (R43 ?V1))
                       (not (R99 ?V1)))
    :effect (and (R43 ?V1)
                 (R119 ?V1)
                 (not (R86 ?V5)))
  )

  (:action A27
    :parameters (?V9 - T5 ?V25 - T14)
    :precondition (and (R53 ?V9)
                       (R51 ?V9 ?V25)
                       (not (R54 ?V9 ?V25)))
    :effect (R54 ?V9 ?V25)
  )

  (:action A12
    :parameters (?V1 - T1 ?V7 - T2)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R14 ?V1 ?V7)
                       (R31 ?V7) (R32 ?V7)
                       (not (R36 ?V7)))
    :effect (and (R34 ?V7)
                 (R35 ?V7)
                 (R36 ?V7))
  )

  (:action A67
    :parameters (?V9 - T5 ?V10 - T10)
    :precondition (and (R49 ?V9)
                       (R52 ?V9 ?V10)
                       (not (R90 ?V9 ?V10)))
    :effect (and (R90 ?V9 ?V10)
                 (not (R52 ?V9 ?V10)))
  )

  (:action A29
    :parameters (?V9 - T5)
    :precondition (and (R55 ?V9)
                       (not (R56 ?V9)))
    :effect (R56 ?V9)
  )

  (:action A53
    :parameters (?V12 - T8)
    :precondition (and (R79 ?V12)
                       (not (R80 ?V12)))
    :effect (R80 ?V12)
  )

  (:action A84
    :parameters (?V7 - T2)
    :precondition (and (R31 ?V7)
                       (R33 ?V7)
                       (not (R108 ?V7)))
    :effect (R108 ?V7)
  )

  (:action A11
    :parameters (?V1 - T1 ?V7 - T2)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R31 ?V7) (R33 ?V7)
                       (not (R32 ?V7)))
    :effect (R32 ?V7)
  )

  (:action A37
    :parameters (?V1 - T1)
    :precondition (and (R2 ?V1)
                       (R63 ?V1)
                       (not (R64 ?V1)))
    :effect (R64 ?V1)
  )

  (:action A50
    :parameters (?V12 - T8 ?V32 - T16)
    :precondition (and (R76 ?V12)
                       (R71 ?V32)
                       (not (R78 ?V12)))
    :effect (and (R78 ?V12)
                 (R72 ?V32) (not (R71 ?V32)))
  )

  (:action A77
    :parameters (?V12 - T8)
    :precondition (and (R76 ?V12)
                       (R79 ?V12)
                       (not (R102 ?V12))
                       (not (R103 ?V12)))
    :effect (R102 ?V12)
  )

  (:action A40
    :parameters (?V2 - T6)
    :precondition (and (R66 ?V2)
                       (not (R67 ?V2)))
    :effect (R67 ?V2)
  )

  (:action A23
  :parameters (?V1 - T1 ?V9 - T5 ?V23 - T10 ?V24 - T10)
  :precondition (and (R1 ?V1) (not (R2 ?V1))
                     (R45 ?V1)
                     (not (R49 ?V9))
                     (not (= ?V23 ?V24)))
  :effect (and (R49 ?V9)
               (R48 ?V9 ?V1)
               (R52 ?V9 ?V23)
               (R52 ?V9 ?V24))
)

  (:action A9
  :parameters (?V1 - T1 ?V8 - T3 ?V14 - T15 ?V15 - T15)
  :precondition (and (R1 ?V1) (not (R2 ?V1))
                     (R16 ?V8 ?V1) (R23 ?V8) (R19 ?V8)
                     (R13 ?V1 ?V14) (R13 ?V1 ?V15)
                     (R36 ?V14) (R36 ?V15)
                     (not (= ?V14 ?V15)))
  :effect (R30 ?V1)
)

  (:action A8
    :parameters (?V1 - T1 ?V8 - T3)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R15 ?V1 ?V8) (R16 ?V8 ?V1)
                       (R18 ?V8) (R23 ?V8)
                       (not (R19 ?V8)))
    :effect (R19 ?V8)
  )

  (:action A87
    :parameters (?V1 - T1 ?V7 - T2)
    :precondition (and (R2 ?V1)
                       (R110 ?V1 ?V7)
                       (not (R111 ?V1 ?V7))
                       (not (R127 ?V1)))
    :effect (R111 ?V1 ?V7)
  )

  (:action A18
  :parameters (?V1 - T1 ?V16 - T14 ?V17 - T14 ?V14 - T15 ?V15 - T15)
  :precondition (and (R1 ?V1) (not (R2 ?V1))
                     (R41 ?V1)
                     (R30 ?V1)
                     (R13 ?V1 ?V16) (R13 ?V1 ?V17) (R13 ?V1 ?V14) (R13 ?V1 ?V15)
                     (R36 ?V16) (R36 ?V17) (R36 ?V14) (R36 ?V15)
                     (not (R42 ?V1))
                     (not (= ?V16 ?V17))
                     (not (= ?V14 ?V15)))
  :effect (and (R42 ?V1) (R43 ?V1))
)

  (:action A76
    :parameters (?V2 - T6)
    :precondition (and (R106 ?V2)
                       (not (R107 ?V2)))
    :effect (R107 ?V2)
  )

  (:action A63
    :parameters (?V1 - T1)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R96 ?V1)
                       (not (R45 ?V1))
                       (not (R97 ?V1))
                       (not (R4 ?V1)))
    :effect (and (R45 ?V1) (R97 ?V1) (not (R96 ?V1)))
  )

  (:action A70
    :parameters (?V1 - T1 ?V9 - T5 ?V4 - T4)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R48 ?V9 ?V1)
                       (R57 ?V9)
                       (R117 ?V9)
                       (R95 ?V9 ?V4)
                       (not (R58 ?V1)))
    :effect (and (R58 ?V1)
                 (R118 ?V9))
  )

  (:action A80
    :parameters (?V3 - T7 ?V12 - T8)
    :precondition (and (R104 ?V3 ?V12)
                       (not (R100 ?V3))
                       (not (R101 ?V3)))
    :effect (R100 ?V3)
  )

  (:action A89
    :parameters (?V4 - T4 ?V10 - T10)
    :precondition (and (R128 ?V4)
                       (not (R129 ?V4 ?V10))
                       (not (R125 ?V10)))
    :effect (and (R129 ?V4 ?V10)
                 (R125 ?V10))
  )

  (:action A59
    :parameters (?V1 - T1 ?V5 - T9)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R85 ?V1 ?V5)
                       (not (R86 ?V5)))
    :effect (R86 ?V5)
  )

  (:action A16
    :parameters (?V1 - T1)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R26 ?V1)
                       (not (R40 ?V1)))
    :effect (R40 ?V1)
  )

  (:action A3
    :parameters (?V1 - T1 ?V13 - T4)
    :precondition (and (R1 ?V1) (not (R2 ?V1)) (not (R4 ?V1)))
    :effect (R12 ?V1 ?V13)
  )

  (:action A36
    :parameters (?V1 - T1 ?V2 - T6)
    :precondition (and (R2 ?V1)
                       (R45 ?V1)
                       (R58 ?V1)
                       (not (R60 ?V1))
                       (not (R61 ?V1 ?V2)))
    :effect (and (R60 ?V1)
                 (R61 ?V1 ?V2)
                 (R62 ?V2)
                 (R63 ?V1))
  )

  (:action A72
    :parameters (?V9 - T5 ?V30 - T18)
    :precondition (and (R94 ?V9)
                       (R71 ?V30))
    :effect (and (not (R94 ?V9))
                 (R72 ?V30) (not (R71 ?V30)))
  )

  (:action A20
    :parameters (?V1 - T1)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R42 ?V1)
                       (not (R5 ?V1)) (not (R6 ?V1)) (not (R4 ?V1))
                       (not (R45 ?V1)))
    :effect (R45 ?V1)
  )

  (:action A79
    :parameters (?V3 - T7 ?V12 - T8)
    :precondition (and (R8 ?V3)
                       (R77 ?V12 ?V3)
                       (R102 ?V12)
                       (not (R104 ?V3 ?V12)))
    :effect (R104 ?V3 ?V12)
  )

  (:action A45
    :parameters (?V2 - T6)
    :precondition (and (R7 ?V2)
                       (not (R69 ?V2)))
    :effect (R69 ?V2)
  )

  (:action A78
    :parameters (?V12 - T8)
    :precondition (and (R76 ?V12)
                       (not (R102 ?V12))
                       (not (R103 ?V12)))
    :effect (R103 ?V12)
  )

  (:action A47
  :parameters (?V1 - T1 ?V3 - T7 ?V25 - T14 ?V31 - T19 ?V9 - T5 ?V4 - T4)
  :precondition (and (R2 ?V1)
                     (R71 ?V31)
                     (R48 ?V9 ?V1) (R57 ?V9)

                     (R50 ?V9 ?V4)
                     (R46 ?V1 ?V4)


                     (R10 ?V4)

                     (R13 ?V1 ?V25)


                     (R36 ?V25)

                     (not (R74 ?V3 ?V1 ?V25)))
  :effect (and (R74 ?V3 ?V1 ?V25)
               (R8 ?V3)
               (R72 ?V31) (not (R71 ?V31)))
)

  (:action A46
    :parameters (?V2 - T6)
    :precondition (and (R69 ?V2)
                       (not (R70 ?V2)))
    :effect (R70 ?V2)
  )

  (:action A34
    :parameters (?V1 - T1 ?V29 - T17)
    :precondition (and (R2 ?V1)
                       (R71 ?V29)
                       (not (R4 ?V1)))
    :effect (and (R1 ?V1) (not (R2 ?V1))
                 (R5 ?V1)
                 (R72 ?V29) (not (R71 ?V29)))
  )

  (:action A61
    :parameters (?V1 - T1 ?V4 - T4 ?V10 - T10)
    :precondition (and (R1 ?V1) (not (R2 ?V1))
                       (R12 ?V1 ?V4)
                       (R47 ?V4)
                       (not (R88 ?V1 ?V10))
                       (not (R89 ?V10)))
    :effect (and (R88 ?V1 ?V10) (R89 ?V10))
  )

  (:action A31
  :parameters (?V1 - T1 ?V9 - T5 ?V26 - T4 ?V27 - T4 ?V28 - T4)
  :precondition (and (R1 ?V1) (not (R2 ?V1))
                     (R48 ?V9 ?V1) (R57 ?V9)
                     (R50 ?V9 ?V26)
                     (R50 ?V9 ?V27)
                     (R50 ?V9 ?V28)
                     (not (R58 ?V1))
                     (not (= ?V26 ?V27))
                     (not (= ?V26 ?V28))
                     (not (= ?V27 ?V28)))
  :effect (R58 ?V1)
)

  (:action A49
  :parameters (?V12 - T8 ?V3 - T7)
  :precondition (and (R8 ?V3)
                     (R75 ?V3)
                     (not (R76 ?V12)))
  :effect (and (R76 ?V12) (R77 ?V12 ?V3))
)

  (:action A28
  :parameters (?V9 - T5 ?V16 - T14 ?V17 - T14)
  :precondition (and (R51 ?V9 ?V16) (R51 ?V9 ?V17)
                     (R54 ?V9 ?V16) (R54 ?V9 ?V17)
                     (not (R55 ?V9))
                     (not (= ?V16 ?V17)))
  :effect (R55 ?V9)
)

)
