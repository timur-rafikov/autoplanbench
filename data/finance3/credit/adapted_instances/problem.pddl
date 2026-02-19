(define (problem acme-credit-line-drawdown-p1)
	(:domain loan-drawdown-ops-realistic-v1)

	(:objects
		corporate_drawdown_case_0 - corporate_drawdown_case
		request_channel_1 request_channel_0 - request_channel


		borrower_signatory_1 borrower_signatory_2 - borrower_signatory
		bank_drawdown_officer_1 bank_drawdown_officer_2 - bank_drawdown_officer


		borrower_signatory_0 - borrower_signatory
		bank_drawdown_officer_0 - bank_drawdown_officer


		drawdown_document_0
		drawdown_document_11
		drawdown_document_6
		drawdown_document_3
		drawdown_document_10 - drawdown_document
		drawdown_document_9
		drawdown_document_2
		drawdown_document_8
		drawdown_document_12 - drawdown_document


		drawdown_document_4
		drawdown_document_7
		drawdown_document_1
		drawdown_document_5 - drawdown_document


		facility_document_8
		facility_document_2
		facility_document_3
		facility_document_4 - facility_document

		facility_document_7
		facility_document_5
		facility_document_1
		facility_document_6
		facility_document_0 - facility_document

		drawdown_packet_0 - drawdown_packet
		signature_slot_0 signature_slot_1 - signature_slot
		payment_instruction_0 - payment_instruction
		disbursement_notice_0 - disbursement_notice
		delivery_package_1 - delivery_package
		delivery_package_0 - delivery_package

		delivery_slot_token_0 - delivery_slot_token
		reopen_key_token_0 - reopen_key_token
		wire_cutoff_window_token_0 - wire_cutoff_window_token
		notice_dispatch_window_token_0 - notice_dispatch_window_token
	)

	(:init


    (facility_requires_fx_review facility_document_5)
    (facility_requires_agent_notice facility_document_1)

		(person_linked_to_case corporate_drawdown_case_0 borrower_signatory_1)
		(person_linked_to_case corporate_drawdown_case_0 borrower_signatory_2)
		(person_linked_to_case corporate_drawdown_case_0 bank_drawdown_officer_1)
		(person_linked_to_case corporate_drawdown_case_0 bank_drawdown_officer_2)
		(person_linked_to_case corporate_drawdown_case_0 borrower_signatory_0)
		(person_linked_to_case corporate_drawdown_case_0 bank_drawdown_officer_0)

		(required_person corporate_drawdown_case_0 borrower_signatory_1)
		(required_person corporate_drawdown_case_0 borrower_signatory_2)
		(required_person corporate_drawdown_case_0 bank_drawdown_officer_1)
		(required_person corporate_drawdown_case_0 bank_drawdown_officer_2)


		(person_in_required_set borrower_signatory_1)
		(person_in_required_set borrower_signatory_2)
		(person_in_required_set bank_drawdown_officer_1)
		(person_in_required_set bank_drawdown_officer_2)


		(required_document corporate_drawdown_case_0 drawdown_document_0)
		(required_document corporate_drawdown_case_0 drawdown_document_11)
		(required_document corporate_drawdown_case_0 drawdown_document_6)
		(required_document corporate_drawdown_case_0 drawdown_document_3)
		(required_document corporate_drawdown_case_0 drawdown_document_10)
		(required_document corporate_drawdown_case_0 drawdown_document_9)
		(required_document corporate_drawdown_case_0 drawdown_document_2)
		(required_document corporate_drawdown_case_0 drawdown_document_8)
		(required_document corporate_drawdown_case_0 drawdown_document_12)

		(document_for_case drawdown_document_0 corporate_drawdown_case_0)
		(document_for_case drawdown_document_11 corporate_drawdown_case_0)
		(document_for_case drawdown_document_6 corporate_drawdown_case_0)
		(document_for_case drawdown_document_3 corporate_drawdown_case_0)
		(document_for_case drawdown_document_10 corporate_drawdown_case_0)

		(document_for_person drawdown_document_9 borrower_signatory_1)
		(document_for_person drawdown_document_2 borrower_signatory_2)
		(document_for_person drawdown_document_8 bank_drawdown_officer_1)
		(document_for_person drawdown_document_12 bank_drawdown_officer_2)

		(document_received drawdown_document_0)
		(document_received drawdown_document_11)
		(document_received drawdown_document_6)
		(document_received drawdown_document_3)
		(document_received drawdown_document_10)
		(document_received drawdown_document_9)
		(document_received drawdown_document_2)
		(document_received drawdown_document_8)
		(document_received drawdown_document_12)


		(doc_is_borrowing_base_certificate drawdown_document_0)
		(doc_is_covenant_compliance_statement drawdown_document_11)
		(doc_is_compliance_certificate drawdown_document_6)
		(doc_is_use_of_proceeds_statement drawdown_document_3)
		(doc_is_fee_calculation_sheet drawdown_document_10)
		(doc_is_authorization_kyc_record drawdown_document_9)
		(doc_is_authorization_kyc_record drawdown_document_2)
		(doc_is_authorization_kyc_record drawdown_document_8)
		(doc_is_authorization_kyc_record drawdown_document_12)


		(document_for_case drawdown_document_4 corporate_drawdown_case_0)
		(document_received drawdown_document_4)
		(doc_is_borrowing_base_certificate drawdown_document_4)

		(document_for_case drawdown_document_7 corporate_drawdown_case_0)
		(document_received drawdown_document_7)

		(document_for_case drawdown_document_1 corporate_drawdown_case_0)
		(document_received drawdown_document_1)

		(document_for_case drawdown_document_5 corporate_drawdown_case_0)
		(document_received drawdown_document_5)
		(doc_is_covenant_compliance_statement drawdown_document_5)


		(facility_eligible_for_case corporate_drawdown_case_0 facility_document_7)
		(facility_eligible_for_case corporate_drawdown_case_0 facility_document_5)
		(facility_eligible_for_case corporate_drawdown_case_0 facility_document_1)


		(token_available delivery_slot_token_0)
		(token_available reopen_key_token_0)
		(token_available wire_cutoff_window_token_0)
		(token_available notice_dispatch_window_token_0)
	)

	(:goal
		(and
			(drawdown_completed corporate_drawdown_case_0)
		)
	)
)
