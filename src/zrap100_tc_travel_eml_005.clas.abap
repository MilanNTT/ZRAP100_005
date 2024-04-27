"! @testing BDEF:ZRAP100_R_TravelTP_005
CLASS zrap100_tc_travel_eml_005 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC FOR TESTING
RISK LEVEL HARMLESS
DURATION SHORT.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-DATA:
      cds_test_environment TYPE REF TO if_cds_test_environment,
      sql_test_environment TYPE REF TO if_osql_test_environment,
      begin_date           TYPE /dmo/begin_date,
      end_date             TYPE /dmo/end_date,
      agency_mock_data     TYPE STANDARD TABLE OF /dmo/agency,
      customer_mock_data   TYPE STANDARD TABLE OF /dmo/customer,
      carrier_mock_data    TYPE STANDARD TABLE OF /dmo/carrier,
      flight_mock_data     TYPE STANDARD TABLE OF /dmo/flight.

    CLASS-METHODS:
      class_setup,    " setup test double framework
      class_teardown. " stop test doubles
    METHODS:
      setup,          " reset test doubles
      teardown.       " rollback any changes

    METHODS:
      " CUT: create with action call and commit
      create_with_action FOR TESTING RAISING cx_static_check.

ENDCLASS.



CLASS zrap100_tc_travel_eml_005 IMPLEMENTATION.
  METHOD class_setup.
    " create the test doubles for the underlying CDS entities
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                      i_for_entities = VALUE #(
                        ( i_for_entity = 'ZRAP100_R_TravelTP_005' ) ) ).

    " create test doubles for additional used tables.
    sql_test_environment = cl_osql_test_environment=>create(
    i_dependency_list = VALUE #( ( '/DMO/AGENCY' )
                                 ( '/DMO/CUSTOMER' )
                                 ( '/DMO/CARRIER' )
                                 ( '/DMO/FLIGHT' ) ) ).

    " prepare the test data
    begin_date = cl_abap_context_info=>get_system_date( ) + 10.
    end_date   = cl_abap_context_info=>get_system_date( ) + 30.

    agency_mock_data   = VALUE #( ( agency_id = '070041' name = 'Agency 070041' ) ).
    customer_mock_data = VALUE #( ( customer_id = '000093' last_name = 'Customer 000093' ) ).
    carrier_mock_data  = VALUE #( ( carrier_id = '123' name = 'carrier 123' ) ).
    flight_mock_data   = VALUE #( ( carrier_id = '123' connection_id = '9876' flight_date = begin_date
                                    price = '2000' currency_code = 'EUR' ) ).


  ENDMETHOD.

  METHOD class_teardown.
    " remove test doubles
    cds_test_environment->destroy(  ).
    sql_test_environment->destroy(  ).
  ENDMETHOD.

  METHOD create_with_action.

  ENDMETHOD.

  METHOD setup.
    " clear the test doubles per test
    cds_test_environment->clear_doubles(  ).
    sql_test_environment->clear_doubles(  ).
    " insert test data into test doubles
    sql_test_environment->insert_test_data( agency_mock_data   ).
    sql_test_environment->insert_test_data( customer_mock_data ).
    sql_test_environment->insert_test_data( carrier_mock_data  ).
    sql_test_environment->insert_test_data( flight_mock_data   ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

ENDCLASS.
