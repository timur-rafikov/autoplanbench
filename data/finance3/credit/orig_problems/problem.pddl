(define (problem acme-credit-line-drawdown-p1)
	(:domain loan-drawdown-ops-realistic-v1)

	(:objects
		acme_drawdown_case - corporate_drawdown_case
		digital_portal relationship_manager_channel - request_channel


		borrower_signer_ivan borrower_signer_maria - borrower_signatory
		bank_ops_officer_alex bank_ops_officer_nadia - bank_drawdown_officer


		borrower_signer_anna_decoy - borrower_signatory
		bank_ops_officer_pavel_decoy - bank_drawdown_officer


		borrowing_base_certificate
		covenant_compliance_statement
		compliance_certificate
		use_of_proceeds_statement
		fee_calculation_sheet - drawdown_document
		auth_record_ivan
		auth_record_maria
		delegation_record_alex
		delegation_record_nadia - drawdown_document


		borrowing_base_certificate_old_decoy
		misc_doc_decoy_1
		misc_doc_decoy_2
		covenant_statement_old_decoy - drawdown_document


		facility_doc_old_version_decoy
		facility_termsheet_decoy
		collateral_agreement_decoy
		pricing_schedule_decoy - facility_document

		facility_agreement_main
		facility_fx_rider
		facility_agent_notice_schedule
		side_letter_decoy
		novation_agreement_decoy - facility_document

		drawdown_packet_1 - drawdown_packet
		signature_slot_a signature_slot_b - signature_slot
		wire_instruction_1 - payment_instruction
		disbursement_notice_1 - disbursement_notice
		delivery_package_1 - delivery_package
		delivery_package_decoy - delivery_package

		delivery_slot_token_1 - delivery_slot_token
		reopen_key_token_1 - reopen_key_token
		wire_cutoff_window_token_1 - wire_cutoff_window_token
		notice_dispatch_window_token_1 - notice_dispatch_window_token
	)

	(:init


    (facility_requires_fx_review facility_fx_rider)
    (facility_requires_agent_notice facility_agent_notice_schedule)

		(person_linked_to_case acme_drawdown_case borrower_signer_ivan)
		(person_linked_to_case acme_drawdown_case borrower_signer_maria)
		(person_linked_to_case acme_drawdown_case bank_ops_officer_alex)
		(person_linked_to_case acme_drawdown_case bank_ops_officer_nadia)
		(person_linked_to_case acme_drawdown_case borrower_signer_anna_decoy)
		(person_linked_to_case acme_drawdown_case bank_ops_officer_pavel_decoy)

		(required_person acme_drawdown_case borrower_signer_ivan)
		(required_person acme_drawdown_case borrower_signer_maria)
		(required_person acme_drawdown_case bank_ops_officer_alex)
		(required_person acme_drawdown_case bank_ops_officer_nadia)


		(person_in_required_set borrower_signer_ivan)
		(person_in_required_set borrower_signer_maria)
		(person_in_required_set bank_ops_officer_alex)
		(person_in_required_set bank_ops_officer_nadia)


		(required_document acme_drawdown_case borrowing_base_certificate)
		(required_document acme_drawdown_case covenant_compliance_statement)
		(required_document acme_drawdown_case compliance_certificate)
		(required_document acme_drawdown_case use_of_proceeds_statement)
		(required_document acme_drawdown_case fee_calculation_sheet)
		(required_document acme_drawdown_case auth_record_ivan)
		(required_document acme_drawdown_case auth_record_maria)
		(required_document acme_drawdown_case delegation_record_alex)
		(required_document acme_drawdown_case delegation_record_nadia)

		(document_for_case borrowing_base_certificate acme_drawdown_case)
		(document_for_case covenant_compliance_statement acme_drawdown_case)
		(document_for_case compliance_certificate acme_drawdown_case)
		(document_for_case use_of_proceeds_statement acme_drawdown_case)
		(document_for_case fee_calculation_sheet acme_drawdown_case)

		(document_for_person auth_record_ivan borrower_signer_ivan)
		(document_for_person auth_record_maria borrower_signer_maria)
		(document_for_person delegation_record_alex bank_ops_officer_alex)
		(document_for_person delegation_record_nadia bank_ops_officer_nadia)

		(document_received borrowing_base_certificate)
		(document_received covenant_compliance_statement)
		(document_received compliance_certificate)
		(document_received use_of_proceeds_statement)
		(document_received fee_calculation_sheet)
		(document_received auth_record_ivan)
		(document_received auth_record_maria)
		(document_received delegation_record_alex)
		(document_received delegation_record_nadia)


		(doc_is_borrowing_base_certificate borrowing_base_certificate)
		(doc_is_covenant_compliance_statement covenant_compliance_statement)
		(doc_is_compliance_certificate compliance_certificate)
		(doc_is_use_of_proceeds_statement use_of_proceeds_statement)
		(doc_is_fee_calculation_sheet fee_calculation_sheet)
		(doc_is_authorization_kyc_record auth_record_ivan)
		(doc_is_authorization_kyc_record auth_record_maria)
		(doc_is_authorization_kyc_record delegation_record_alex)
		(doc_is_authorization_kyc_record delegation_record_nadia)


		(document_for_case borrowing_base_certificate_old_decoy acme_drawdown_case)
		(document_received borrowing_base_certificate_old_decoy)
		(doc_is_borrowing_base_certificate borrowing_base_certificate_old_decoy)

		(document_for_case misc_doc_decoy_1 acme_drawdown_case)
		(document_received misc_doc_decoy_1)

		(document_for_case misc_doc_decoy_2 acme_drawdown_case)
		(document_received misc_doc_decoy_2)

		(document_for_case covenant_statement_old_decoy acme_drawdown_case)
		(document_received covenant_statement_old_decoy)
		(doc_is_covenant_compliance_statement covenant_statement_old_decoy)


		(facility_eligible_for_case acme_drawdown_case facility_agreement_main)
		(facility_eligible_for_case acme_drawdown_case facility_fx_rider)
		(facility_eligible_for_case acme_drawdown_case facility_agent_notice_schedule)


		(token_available delivery_slot_token_1)
		(token_available reopen_key_token_1)
		(token_available wire_cutoff_window_token_1)
		(token_available notice_dispatch_window_token_1)
	)

	(:goal
		(and
			(drawdown_completed acme_drawdown_case)
		)
	)
)
