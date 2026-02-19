(define (domain loan-drawdown-ops-realistic-v1)
(:requirements :strips :typing :negative-preconditions :equality)

  (:types
    entity - object
    drawdown_case participant_person drawdown_document facility_document drawdown_packet payment_instruction disbursement_notice delivery_package request_channel signature_slot resource_token - entity
    corporate_drawdown_case - drawdown_case
    borrower_signatory bank_drawdown_officer - participant_person
    delivery_slot_token reopen_key_token wire_cutoff_window_token notice_dispatch_window_token - resource_token
  )

  (:predicates

    (drawdown_open ?case - drawdown_case)
    (drawdown_locked ?case - drawdown_case)
    (drawdown_completed ?case - drawdown_case)
    (drawdown_frozen ?case - drawdown_case)
    (compliance_hold_flag ?case - drawdown_case)
    (suspicious_payment_flag ?case - drawdown_case)
    (wire_released ?payment_instruction - payment_instruction)
    (notice_created ?notice - disbursement_notice)
    (facility_requires_fx_review ?facility_doc - facility_document)
    (facility_requires_agent_notice ?facility_doc - facility_document)




    (channel_selected ?case - drawdown_case ?channel - request_channel)
    (facility_selected ?case - drawdown_case ?facility_doc - facility_document)


    (required_person ?case - drawdown_case ?person - participant_person)
    (person_linked_to_case ?case - drawdown_case ?person - participant_person)


    (required_document ?case - drawdown_case ?doc - drawdown_document)
    (document_for_case ?doc - drawdown_document ?case - drawdown_case)
    (document_for_person ?doc - drawdown_document ?person - participant_person)
    (document_received ?doc - drawdown_document)
    (document_verified ?doc - drawdown_document)


    (doc_is_borrowing_base_certificate ?doc - drawdown_document)
    (doc_is_compliance_certificate ?doc - drawdown_document)
    (doc_is_covenant_compliance_statement ?doc - drawdown_document)
    (doc_is_fee_calculation_sheet ?doc - drawdown_document)
    (doc_is_use_of_proceeds_statement ?doc - drawdown_document)
    (doc_is_authorization_kyc_record ?doc - drawdown_document)


    (borrowing_base_verified ?case - drawdown_case)
    (compliance_certificate_verified ?case - drawdown_case)
    (covenant_statement_verified ?case - drawdown_case)
    (use_of_proceeds_verified ?case - drawdown_case)
    (two_officer_signoff_recorded ?case - drawdown_case)


    (person_auth_doc_verified ?person - participant_person)
    (person_contact_verified ?person - participant_person)
    (person_in_required_set ?person - participant_person)


    (person_sanctions_checked ?person - participant_person)
    (person_pep_checked ?person - participant_person)
    (person_full_clearance ?person - participant_person)

    (availability_calculated ?case - drawdown_case)
    (limit_headroom_confirmed ?case - drawdown_case)
    (basic_drawdown_checks_complete ?case - drawdown_case)


    (fast_track_enabled ?case - drawdown_case)


    (drawdown_package_compiled ?case - drawdown_case)


    (credit_ops_approved ?case - drawdown_case)
    (risk_approved ?case - drawdown_case)
    (auto_approved ?case - drawdown_case)
    (packet_creation_authorized ?case - drawdown_case)


    (facility_eligible_for_case ?case - drawdown_case ?facility_doc - facility_document)
    (facility_document_validated ?facility_doc - facility_document)

    (packet_for_case ?packet - drawdown_packet ?case - drawdown_case)
    (packet_created ?packet - drawdown_packet)
    (packet_attached_facility_document ?packet - drawdown_packet ?facility_doc - facility_document)
    (packet_assigned_signer ?packet - drawdown_packet ?borrower_signer - borrower_signatory)
    (packet_has_signature_slot ?packet - drawdown_packet ?signature_slot - signature_slot)

    (signature_collection_started ?packet - drawdown_packet)
    (signature_captured ?packet - drawdown_packet ?borrower_signer - borrower_signatory)
    (two_signatures_verified ?packet - drawdown_packet)
    (packet_compliance_checked ?packet - drawdown_packet)
    (packet_finalized ?packet - drawdown_packet)
    (drawdown_packet_complete ?case - drawdown_case)

    (packet_reopened ?packet - drawdown_packet)


    (payment_instruction_drafted ?case - drawdown_case)
    (case_has_payment_instruction ?case - drawdown_case ?payment_instruction - payment_instruction)
    (payment_instruction_created ?payment_instruction - payment_instruction)
    (payment_instruction_validated ?case - drawdown_case)
    (payment_instruction_approved ?case - drawdown_case)
    (payment_instruction_ready_to_sign ?case - drawdown_case)
    (payment_instruction_signed ?payment_instruction - payment_instruction)
    (payment_instruction_sent_to_treasury ?payment_instruction - payment_instruction)
    (payment_instruction_executed ?payment_instruction - payment_instruction)
    (beneficiary_credited ?payment_instruction - payment_instruction)
    (funds_settled ?payment_instruction - payment_instruction)


    (token_available ?token - resource_token)
    (token_consumed ?token - resource_token)
    (wire_cutoff_reserved ?payment_instruction - payment_instruction)


    (notice_addressed_to_signer ?notice - disbursement_notice ?case - drawdown_case ?borrower_signer - borrower_signatory)
    (notice_approved ?notice - disbursement_notice)
    (delivery_package_created ?delivery_package - delivery_package)
    (package_for_notice ?delivery_package - delivery_package ?notice - disbursement_notice)
    (package_labeled ?delivery_package - delivery_package)
    (label_printed ?delivery_package - delivery_package)
    (label_scanned ?delivery_package - delivery_package)
    (notice_ready_to_send ?notice - disbursement_notice)
    (notice_sent ?notice - disbursement_notice)


    (senior_override_assigned ?case - drawdown_case)


    (final_controls_complete ?case - drawdown_case)
  )




  (:action open_drawdown_case
    :parameters (?case - drawdown_case)
    :precondition (and (not (drawdown_open ?case)) (not (drawdown_completed ?case)) (not (drawdown_frozen ?case)))
    :effect (drawdown_open ?case)
  )

  (:action select_request_channel
    :parameters (?case - drawdown_case ?channel - request_channel)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case)) (not (drawdown_frozen ?case)))
    :effect (channel_selected ?case ?channel)
  )


  (:action select_facility_document
    :parameters (?case - drawdown_case ?facility_doc - facility_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case)) (not (drawdown_frozen ?case)))
    :effect (facility_selected ?case ?facility_doc)
  )




  (:action verify_borrowing_base_certificate
    :parameters (?case - drawdown_case ?borrowing_base_doc - drawdown_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (required_document ?case ?borrowing_base_doc) (document_for_case ?borrowing_base_doc ?case)
                       (document_received ?borrowing_base_doc) (doc_is_borrowing_base_certificate ?borrowing_base_doc)
                       (not (document_verified ?borrowing_base_doc)))
    :effect (and (document_verified ?borrowing_base_doc) (borrowing_base_verified ?case))
  )

  (:action verify_compliance_certificate
    :parameters (?case - drawdown_case ?compliance_cert_doc - drawdown_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (required_document ?case ?compliance_cert_doc) (document_for_case ?compliance_cert_doc ?case)
                       (document_received ?compliance_cert_doc) (doc_is_compliance_certificate ?compliance_cert_doc)
                       (not (document_verified ?compliance_cert_doc)))
    :effect (and (document_verified ?compliance_cert_doc) (compliance_certificate_verified ?case))
  )

  (:action verify_covenant_compliance_statement
    :parameters (?case - drawdown_case ?covenant_statement_doc - drawdown_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (required_document ?case ?covenant_statement_doc) (document_for_case ?covenant_statement_doc ?case)
                       (document_received ?covenant_statement_doc) (doc_is_covenant_compliance_statement ?covenant_statement_doc)
                       (not (document_verified ?covenant_statement_doc)))
    :effect (and (document_verified ?covenant_statement_doc) (covenant_statement_verified ?case))
  )

  (:action verify_use_of_proceeds_statement
    :parameters (?case - drawdown_case ?use_of_proceeds_doc - drawdown_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (required_document ?case ?use_of_proceeds_doc) (document_for_case ?use_of_proceeds_doc ?case)
                       (document_received ?use_of_proceeds_doc) (doc_is_use_of_proceeds_statement ?use_of_proceeds_doc)
                       (not (document_verified ?use_of_proceeds_doc)))
    :effect (and (document_verified ?use_of_proceeds_doc) (use_of_proceeds_verified ?case))
  )

  (:action verify_fee_calculation_sheet
    :parameters (?case - drawdown_case ?fee_calc_doc - drawdown_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (required_document ?case ?fee_calc_doc) (document_for_case ?fee_calc_doc ?case)
                       (document_received ?fee_calc_doc) (doc_is_fee_calculation_sheet ?fee_calc_doc)
                       (not (document_verified ?fee_calc_doc)))
    :effect (document_verified ?fee_calc_doc)
  )

  (:action record_two_officer_signoff
  :parameters (?case - drawdown_case ?fee_calc_doc - drawdown_document ?officer_1 - bank_drawdown_officer ?officer_2 - bank_drawdown_officer)
  :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                     (document_for_case ?fee_calc_doc ?case) (doc_is_fee_calculation_sheet ?fee_calc_doc) (document_verified ?fee_calc_doc)
                     (required_person ?case ?officer_1) (required_person ?case ?officer_2)
                     (person_full_clearance ?officer_1) (person_full_clearance ?officer_2)
                     (not (= ?officer_1 ?officer_2)))
  :effect (two_officer_signoff_recorded ?case)
)


  (:action verify_person_authorization_record
    :parameters (?case - drawdown_case ?person - participant_person ?auth_kyc_doc - drawdown_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (required_document ?case ?auth_kyc_doc) (document_for_person ?auth_kyc_doc ?person)
                       (document_received ?auth_kyc_doc) (doc_is_authorization_kyc_record ?auth_kyc_doc)
                       (not (document_verified ?auth_kyc_doc)))
    :effect (and (document_verified ?auth_kyc_doc) (person_auth_doc_verified ?person))
  )

  (:action verify_person_contact_details
    :parameters (?case - drawdown_case ?person - participant_person)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (person_auth_doc_verified ?person) (person_in_required_set ?person)
                       (not (person_contact_verified ?person)))
    :effect (person_contact_verified ?person)
  )




  (:action run_full_person_screening
    :parameters (?case - drawdown_case ?person - participant_person)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (person_linked_to_case ?case ?person)
                       (person_auth_doc_verified ?person) (person_contact_verified ?person)
                       (not (person_full_clearance ?person)))
    :effect (and (person_sanctions_checked ?person)
                 (person_pep_checked ?person)
                 (person_full_clearance ?person))
  )


  (:action run_sanctions_screening_only
    :parameters (?case - drawdown_case ?person - participant_person)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (person_linked_to_case ?case ?person)
                       (person_auth_doc_verified ?person)
                       (not (person_sanctions_checked ?person)))
    :effect (person_sanctions_checked ?person)
  )


  (:action run_pep_screening_only
    :parameters (?case - drawdown_case ?person - participant_person)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (person_linked_to_case ?case ?person)
                       (person_auth_doc_verified ?person)
                       (not (person_pep_checked ?person)))
    :effect (person_pep_checked ?person)
  )

  (:action complete_basic_drawdown_checks
    :parameters (?case - drawdown_case)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (borrowing_base_verified ?case)
                       (not (basic_drawdown_checks_complete ?case)))
    :effect (and (availability_calculated ?case)
                 (limit_headroom_confirmed ?case)
                 (basic_drawdown_checks_complete ?case))
  )



  (:action enable_fast_track
    :parameters (?case - drawdown_case)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (borrowing_base_verified ?case)
                       (not (fast_track_enabled ?case)))
    :effect (fast_track_enabled ?case)
  )




  (:action compile_drawdown_package
  :parameters (?case - drawdown_case
               ?borrower_signer_1 - borrower_signatory ?borrower_signer_2 - borrower_signatory ?bank_officer_1 - bank_drawdown_officer ?bank_officer_2 - bank_drawdown_officer
               ?borrowing_base_doc - drawdown_document ?covenant_statement_doc - drawdown_document ?compliance_cert_doc - drawdown_document ?use_of_proceeds_doc - drawdown_document ?fee_calc_doc - drawdown_document)
  :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                     (borrowing_base_verified ?case) (covenant_statement_verified ?case) (compliance_certificate_verified ?case) (use_of_proceeds_verified ?case)
                     (document_for_case ?borrowing_base_doc ?case) (doc_is_borrowing_base_certificate ?borrowing_base_doc) (document_verified ?borrowing_base_doc)
                     (document_for_case ?covenant_statement_doc ?case) (doc_is_covenant_compliance_statement ?covenant_statement_doc) (document_verified ?covenant_statement_doc)
                     (document_for_case ?compliance_cert_doc ?case) (doc_is_compliance_certificate ?compliance_cert_doc) (document_verified ?compliance_cert_doc)
                     (document_for_case ?use_of_proceeds_doc ?case) (doc_is_use_of_proceeds_statement ?use_of_proceeds_doc) (document_verified ?use_of_proceeds_doc)
                     (document_for_case ?fee_calc_doc ?case) (doc_is_fee_calculation_sheet ?fee_calc_doc) (document_verified ?fee_calc_doc)
                     (required_person ?case ?borrower_signer_1) (required_person ?case ?borrower_signer_2) (required_person ?case ?bank_officer_1) (required_person ?case ?bank_officer_2)
                     (person_full_clearance ?borrower_signer_1) (person_full_clearance ?borrower_signer_2) (person_full_clearance ?bank_officer_1) (person_full_clearance ?bank_officer_2)
                     (basic_drawdown_checks_complete ?case)
                     (not (drawdown_package_compiled ?case))
                     (not (= ?borrower_signer_1 ?borrower_signer_2))
                     (not (= ?bank_officer_1 ?bank_officer_2)))
  :effect (drawdown_package_compiled ?case)
)





  (:action approve_drawdown_package_four_eyes
  :parameters (?case - drawdown_case ?borrower_signer_1 - borrower_signatory ?borrower_signer_2 - borrower_signatory ?bank_officer_1 - bank_drawdown_officer ?bank_officer_2 - bank_drawdown_officer)
  :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                     (drawdown_package_compiled ?case)
                     (two_officer_signoff_recorded ?case)
                     (required_person ?case ?borrower_signer_1) (required_person ?case ?borrower_signer_2) (required_person ?case ?bank_officer_1) (required_person ?case ?bank_officer_2)
                     (person_full_clearance ?borrower_signer_1) (person_full_clearance ?borrower_signer_2) (person_full_clearance ?bank_officer_1) (person_full_clearance ?bank_officer_2)
                     (not (credit_ops_approved ?case))
                     (not (= ?borrower_signer_1 ?borrower_signer_2))
                     (not (= ?bank_officer_1 ?bank_officer_2)))
  :effect (and (credit_ops_approved ?case) (risk_approved ?case))
)




  (:action approve_drawdown_package_fast_track
    :parameters (?case - drawdown_case)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (fast_track_enabled ?case)
                       (borrowing_base_verified ?case) (covenant_statement_verified ?case)
                       (not (credit_ops_approved ?case)))
    :effect (and (credit_ops_approved ?case) (auto_approved ?case))
  )

  (:action authorize_packet_creation
    :parameters (?case - drawdown_case)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (credit_ops_approved ?case)
                       (not (compliance_hold_flag ?case)) (not (suspicious_payment_flag ?case)) (not (drawdown_frozen ?case))
                       (not (packet_creation_authorized ?case)))
    :effect (packet_creation_authorized ?case)
  )


  (:action raise_compliance_hold
    :parameters (?case - drawdown_case)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case)) (not (compliance_hold_flag ?case)))
    :effect (compliance_hold_flag ?case)
  )




  (:action validate_facility_document
    :parameters (?case - drawdown_case ?facility_doc - facility_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (facility_eligible_for_case ?case ?facility_doc)
                       (packet_creation_authorized ?case)
                       (not (facility_document_validated ?facility_doc)))
    :effect (facility_document_validated ?facility_doc)
  )

  (:action create_drawdown_packet
  :parameters (?case - drawdown_case ?packet - drawdown_packet ?signature_slot_1 - signature_slot ?signature_slot_2 - signature_slot)
  :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                     (packet_creation_authorized ?case)
                     (not (packet_created ?packet))
                     (not (= ?signature_slot_1 ?signature_slot_2)))
  :effect (and (packet_created ?packet)
               (packet_for_case ?packet ?case)
               (packet_has_signature_slot ?packet ?signature_slot_1)
               (packet_has_signature_slot ?packet ?signature_slot_2))
)


  (:action attach_facility_document_to_packet
    :parameters (?case - drawdown_case ?packet - drawdown_packet ?facility_doc - facility_document)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (packet_for_case ?packet ?case)
                       (packet_created ?packet)
                       (facility_document_validated ?facility_doc)
                       (not (packet_finalized ?packet))
                       (not (packet_attached_facility_document ?packet ?facility_doc)))
    :effect (packet_attached_facility_document ?packet ?facility_doc)
  )

  (:action assign_signer_to_packet_slot
    :parameters (?case - drawdown_case ?packet - drawdown_packet ?borrower_signer - borrower_signatory ?signature_slot - signature_slot)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (packet_for_case ?packet ?case)
                       (packet_created ?packet)
                       (required_person ?case ?borrower_signer)
                       (person_auth_doc_verified ?borrower_signer) (person_contact_verified ?borrower_signer)
                       (packet_has_signature_slot ?packet ?signature_slot)
                       (not (packet_assigned_signer ?packet ?borrower_signer)))
    :effect (and (packet_assigned_signer ?packet ?borrower_signer)
                 (not (packet_has_signature_slot ?packet ?signature_slot)))
  )

  (:action start_signature_collection
    :parameters (?packet - drawdown_packet)
    :precondition (and (packet_created ?packet)
                       (not (packet_finalized ?packet))
                       (not (signature_collection_started ?packet)))
    :effect (signature_collection_started ?packet)
  )

  (:action capture_signer_signature
    :parameters (?packet - drawdown_packet ?borrower_signer - borrower_signatory)
    :precondition (and (signature_collection_started ?packet)
                       (packet_assigned_signer ?packet ?borrower_signer)
                       (not (signature_captured ?packet ?borrower_signer)))
    :effect (signature_captured ?packet ?borrower_signer)
  )

  (:action verify_two_distinct_signatures
  :parameters (?packet - drawdown_packet ?borrower_signer_1 - borrower_signatory ?borrower_signer_2 - borrower_signatory)
  :precondition (and (packet_assigned_signer ?packet ?borrower_signer_1) (packet_assigned_signer ?packet ?borrower_signer_2)
                     (signature_captured ?packet ?borrower_signer_1) (signature_captured ?packet ?borrower_signer_2)
                     (not (two_signatures_verified ?packet))
                     (not (= ?borrower_signer_1 ?borrower_signer_2)))
  :effect (two_signatures_verified ?packet)
)


  (:action perform_packet_compliance_check
    :parameters (?packet - drawdown_packet)
    :precondition (and (two_signatures_verified ?packet)
                       (not (packet_compliance_checked ?packet)))
    :effect (packet_compliance_checked ?packet)
  )

  (:action finalize_drawdown_packet
    :parameters (?packet - drawdown_packet)
    :precondition (and (packet_compliance_checked ?packet)
                       (not (packet_finalized ?packet)))
    :effect (and (packet_finalized ?packet) (not (signature_collection_started ?packet)))
  )


  (:action confirm_packet_has_three_facility_docs
  :parameters (?case - drawdown_case ?packet - drawdown_packet ?facility_doc_1 - facility_document ?facility_doc_2 - facility_document ?facility_doc_3 - facility_document)
  :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                     (packet_for_case ?packet ?case) (packet_finalized ?packet)
                     (packet_attached_facility_document ?packet ?facility_doc_1)
                     (packet_attached_facility_document ?packet ?facility_doc_2)
                     (packet_attached_facility_document ?packet ?facility_doc_3)
                     (not (drawdown_packet_complete ?case))
                     (not (= ?facility_doc_1 ?facility_doc_2))
                     (not (= ?facility_doc_1 ?facility_doc_3))
                     (not (= ?facility_doc_2 ?facility_doc_3)))
  :effect (drawdown_packet_complete ?case)
)




  (:action reopen_packet_and_reset_signatures
    :parameters (?case - drawdown_case ?packet - drawdown_packet ?reopen_token - reopen_key_token ?signature_slot_1 - signature_slot ?signature_slot_2 - signature_slot)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case))
                       (packet_for_case ?packet ?case)
                       (packet_created ?packet)
                       (token_available ?reopen_token)
                       (not (packet_reopened ?packet)))
    :effect (and (packet_reopened ?packet)
                 (token_consumed ?reopen_token)
                 (not (token_available ?reopen_token))
                 (not (packet_finalized ?packet))
                 (not (packet_compliance_checked ?packet))
                 (not (two_signatures_verified ?packet))
                 (not (signature_collection_started ?packet))
                 (packet_has_signature_slot ?packet ?signature_slot_1)
                 (packet_has_signature_slot ?packet ?signature_slot_2))
  )




  (:action lock_case_for_execution
    :parameters (?case - drawdown_case ?packet - drawdown_packet)
    :precondition (and (drawdown_open ?case)
                       (drawdown_packet_complete ?case)
                       (packet_for_case ?packet ?case) (packet_finalized ?packet)
                       (packet_creation_authorized ?case)
                       (not (drawdown_locked ?case))
                       (not (drawdown_frozen ?case)))
    :effect (and (drawdown_locked ?case) (not (drawdown_open ?case)))
  )

  (:action reopen_locked_case
    :parameters (?case - drawdown_case ?reopen_token - reopen_key_token)
    :precondition (and (drawdown_locked ?case)
                       (token_available ?reopen_token)
                       (not (drawdown_frozen ?case)))
    :effect (and (drawdown_open ?case) (not (drawdown_locked ?case))
                 (compliance_hold_flag ?case)
                 (token_consumed ?reopen_token) (not (token_available ?reopen_token)))
  )




  (:action freeze_case_due_to_suspicious_payment
    :parameters (?case - drawdown_case ?payment_instruction - payment_instruction)
    :precondition (and (drawdown_open ?case) (not (drawdown_locked ?case)) (not (packet_creation_authorized ?case))
                       (not (drawdown_frozen ?case)))
    :effect (and (case_has_payment_instruction ?case ?payment_instruction)
                 (suspicious_payment_flag ?case)
                 (drawdown_frozen ?case))
  )

  (:action draft_payment_instruction
    :parameters (?case - drawdown_case ?payment_instruction - payment_instruction)
    :precondition (and (drawdown_locked ?case)
                       (packet_creation_authorized ?case)
                       (drawdown_packet_complete ?case)
                       (not (payment_instruction_drafted ?case))
                       (not (case_has_payment_instruction ?case ?payment_instruction)))
    :effect (and (payment_instruction_drafted ?case)
                 (case_has_payment_instruction ?case ?payment_instruction)
                 (payment_instruction_created ?payment_instruction)
                 (payment_instruction_validated ?case))
  )

  (:action validate_payment_instruction
    :parameters (?case - drawdown_case)
    :precondition (and (drawdown_locked ?case)
                       (payment_instruction_validated ?case)
                       (not (payment_instruction_approved ?case)))
    :effect (payment_instruction_approved ?case)
  )

  (:action approve_payment_instruction
    :parameters (?case - drawdown_case)
    :precondition (and (drawdown_locked ?case)
                       (payment_instruction_approved ?case)
                       (not (payment_instruction_ready_to_sign ?case)))
    :effect (payment_instruction_ready_to_sign ?case)
  )

  (:action sign_payment_instruction
    :parameters (?payment_instruction - payment_instruction ?case - drawdown_case)
    :precondition (and (drawdown_locked ?case)
                       (payment_instruction_created ?payment_instruction)
                       (payment_instruction_ready_to_sign ?case)
                       (not (payment_instruction_signed ?payment_instruction)))
    :effect (payment_instruction_signed ?payment_instruction)
  )

  (:action send_instruction_to_treasury
    :parameters (?payment_instruction - payment_instruction)
    :precondition (and (payment_instruction_signed ?payment_instruction)
                       (not (payment_instruction_sent_to_treasury ?payment_instruction)))
    :effect (payment_instruction_sent_to_treasury ?payment_instruction)
  )

  (:action execute_treasury_release
  :parameters (?payment_instruction - payment_instruction ?case - drawdown_case ?packet - drawdown_packet ?facility_doc - facility_document)
  :precondition (and (drawdown_locked ?case)
                     (packet_creation_authorized ?case)
                     (risk_approved ?case)
                     (payment_instruction_sent_to_treasury ?payment_instruction)
                     (packet_for_case ?packet ?case) (packet_finalized ?packet)

                     (packet_attached_facility_document ?packet ?facility_doc)
                     (facility_eligible_for_case ?case ?facility_doc)


                     (facility_requires_fx_review ?facility_doc)

                     (covenant_statement_verified ?case) (use_of_proceeds_verified ?case)
                     (not (payment_instruction_executed ?payment_instruction)))
  :effect (payment_instruction_executed ?payment_instruction)
)


  (:action reserve_wire_cutoff_window
    :parameters (?payment_instruction - payment_instruction ?cutoff_window_token - wire_cutoff_window_token)
    :precondition (and (payment_instruction_executed ?payment_instruction)
                       (token_available ?cutoff_window_token)
                       (not (wire_cutoff_reserved ?payment_instruction)))
    :effect (and (wire_cutoff_reserved ?payment_instruction)
                 (token_consumed ?cutoff_window_token) (not (token_available ?cutoff_window_token)))
  )


  (:action consume_cutoff_window_without_reservation
    :parameters (?case - drawdown_case ?cutoff_window_token - wire_cutoff_window_token)
    :precondition (and (drawdown_locked ?case) (token_available ?cutoff_window_token) (not (drawdown_frozen ?case)))
    :effect (and (token_consumed ?cutoff_window_token) (not (token_available ?cutoff_window_token)))
  )

  (:action release_wire_payment
    :parameters (?payment_instruction - payment_instruction)
    :precondition (and (wire_cutoff_reserved ?payment_instruction)
                       (not (beneficiary_credited ?payment_instruction))
                       (not (wire_released ?payment_instruction)))
    :effect (wire_released ?payment_instruction)
  )

  (:action confirm_beneficiary_credit
    :parameters (?payment_instruction - payment_instruction)
    :precondition (and (wire_released ?payment_instruction)
                       (not (beneficiary_credited ?payment_instruction)))
    :effect (beneficiary_credited ?payment_instruction)
  )

  (:action mark_funds_settled
    :parameters (?payment_instruction - payment_instruction)
    :precondition (and (beneficiary_credited ?payment_instruction)
                       (not (funds_settled ?payment_instruction)))
    :effect (funds_settled ?payment_instruction)
  )




  (:action create_disbursement_notice
  :parameters (?case - drawdown_case ?notice - disbursement_notice ?borrower_signer - borrower_signatory ?dispatch_window_token - notice_dispatch_window_token ?packet - drawdown_packet ?facility_doc - facility_document)
  :precondition (and (drawdown_locked ?case)
                     (token_available ?dispatch_window_token)
                     (packet_for_case ?packet ?case) (packet_finalized ?packet)

                     (packet_attached_facility_document ?packet ?facility_doc)
                     (facility_eligible_for_case ?case ?facility_doc)


                     (facility_requires_agent_notice ?facility_doc)

                     (required_person ?case ?borrower_signer)


                     (person_full_clearance ?borrower_signer)

                     (not (notice_addressed_to_signer ?notice ?case ?borrower_signer)))
  :effect (and (notice_addressed_to_signer ?notice ?case ?borrower_signer)
               (notice_created ?notice)
               (token_consumed ?dispatch_window_token) (not (token_available ?dispatch_window_token)))
)


  (:action approve_disbursement_notice
  :parameters (?notice - disbursement_notice)
  :precondition (and (notice_created ?notice)
                     (not (notice_approved ?notice)))
  :effect (notice_approved ?notice)
)


  (:action create_notice_delivery_package
  :parameters (?delivery_package - delivery_package ?notice - disbursement_notice)
  :precondition (and (notice_created ?notice)
                     (notice_approved ?notice)
                     (not (delivery_package_created ?delivery_package)))
  :effect (and (delivery_package_created ?delivery_package) (package_for_notice ?delivery_package ?notice))
)


  (:action apply_delivery_label
    :parameters (?delivery_package - delivery_package ?delivery_slot_token - delivery_slot_token)
    :precondition (and (delivery_package_created ?delivery_package)
                       (token_available ?delivery_slot_token)
                       (not (package_labeled ?delivery_package)))
    :effect (and (package_labeled ?delivery_package)
                 (token_consumed ?delivery_slot_token) (not (token_available ?delivery_slot_token)))
  )


  (:action assign_senior_override_review
    :parameters (?case - drawdown_case ?delivery_slot_token - delivery_slot_token)
    :precondition (and (drawdown_locked ?case) (token_available ?delivery_slot_token) (not (senior_override_assigned ?case)))
    :effect (and (senior_override_assigned ?case)
                 (token_consumed ?delivery_slot_token) (not (token_available ?delivery_slot_token)))
  )

  (:action print_delivery_label
    :parameters (?delivery_package - delivery_package)
    :precondition (and (package_labeled ?delivery_package)
                       (not (label_printed ?delivery_package)))
    :effect (label_printed ?delivery_package)
  )

  (:action scan_delivery_label
    :parameters (?delivery_package - delivery_package)
    :precondition (and (label_printed ?delivery_package)
                       (not (label_scanned ?delivery_package)))
    :effect (label_scanned ?delivery_package)
  )

  (:action mark_notice_ready
    :parameters (?notice - disbursement_notice)
    :precondition (and (not (notice_ready_to_send ?notice)))
    :effect (notice_ready_to_send ?notice)
  )

  (:action send_notice_via_secure_delivery
  :parameters (?notice - disbursement_notice ?payment_instruction - payment_instruction ?case - drawdown_case ?delivery_package - delivery_package ?borrower_signer - borrower_signatory)
  :precondition (and
                 (drawdown_locked ?case)
                 (not (drawdown_frozen ?case))


                 (notice_addressed_to_signer ?notice ?case ?borrower_signer)
                 (notice_created ?notice)


                 (case_has_payment_instruction ?case ?payment_instruction)
                 (payment_instruction_created ?payment_instruction)


                 (package_for_notice ?delivery_package ?notice)
                 (label_scanned ?delivery_package)

                 (notice_ready_to_send ?notice)
                 (not (notice_sent ?notice)))
  :effect (notice_sent ?notice)
)







  (:action complete_final_controls
  :parameters (?case - drawdown_case ?borrower_signer_1 - borrower_signatory ?borrower_signer_2 - borrower_signatory ?bank_officer_1 - bank_drawdown_officer ?bank_officer_2 - bank_drawdown_officer ?payment_instruction - payment_instruction ?notice - disbursement_notice)
  :precondition (and
                  (drawdown_locked ?case)
                  (packet_creation_authorized ?case) (risk_approved ?case)
                  (drawdown_package_compiled ?case)
                  (two_officer_signoff_recorded ?case)

                  (required_person ?case ?borrower_signer_1) (required_person ?case ?borrower_signer_2) (required_person ?case ?bank_officer_1) (required_person ?case ?bank_officer_2)
                  (person_full_clearance ?borrower_signer_1) (person_full_clearance ?borrower_signer_2) (person_full_clearance ?bank_officer_1) (person_full_clearance ?bank_officer_2)


                  (not (= ?borrower_signer_1 ?borrower_signer_2))
                  (not (= ?bank_officer_1 ?bank_officer_2))

                  (funds_settled ?payment_instruction)
                  (notice_sent ?notice)

                  (not (compliance_hold_flag ?case))
                  (not (suspicious_payment_flag ?case))
                  (not (drawdown_frozen ?case))
                  (not (final_controls_complete ?case)))
  :effect (final_controls_complete ?case)
)



  (:action close_drawdown_case
    :parameters (?case - drawdown_case ?payment_instruction - payment_instruction ?notice - disbursement_notice)
    :precondition (and (drawdown_locked ?case)
                       (final_controls_complete ?case)
                       (payment_instruction_created ?payment_instruction)
                       (payment_instruction_executed ?payment_instruction)
                       (beneficiary_credited ?payment_instruction)
                       (notice_sent ?notice)
                       (not (drawdown_completed ?case)))
    :effect (and (drawdown_completed ?case) (not (drawdown_locked ?case)))
  )
)
