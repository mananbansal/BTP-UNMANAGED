CLASS zcl_zcus_details DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_zcus_details IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

  DATA : lt_final_out TYPE STANDARD TABLE OF ztumi_custom WITH EMPTY KEY.



    SELECT h~Docno, itm~item_no, h~status, h~currency , h~CreatedBy , itm~quantity , itm~amount
    FROM ztumi_header AS h
    LEFT OUTER JOIN ztum_item AS itm
    ON h~docno = itm~docno
    INTO TABLE @lt_final_out.


    SORT lt_final_out BY docno.

    IF io_request->is_data_requested( ).
      io_response->set_data( lt_final_out ).
    ENDIF.

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( lt_final_out ) ).
    ENDIF.




    io_request->get_sort_elements( ).
    io_request->get_paging( ).

  ENDMETHOD.
ENDCLASS.
