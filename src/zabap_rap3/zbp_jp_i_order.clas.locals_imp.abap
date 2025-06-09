CLASS lhc_order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR order RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR order RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE order.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE order.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE order.

    METHODS read FOR READ
      IMPORTING keys FOR READ order RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK order.

    METHODS rba_item FOR READ
      IMPORTING keys_rba FOR READ order\_item FULL result_requested RESULT result LINK association_links.

    METHODS cba_item FOR MODIFY
      IMPORTING entities_cba FOR CREATE order\_item.

    METHODS set_status_conf FOR MODIFY
      IMPORTING keys FOR ACTION order~set_status_conf RESULT result.

ENDCLASS.

CLASS lhc_order IMPLEMENTATION.

  METHOD get_instance_features.

    READ ENTITIES OF zjp_i_order IN LOCAL MODE
        ENTITY order
       FIELDS (  ordernumber status )
       WITH CORRESPONDING #( keys )
       RESULT DATA(lt_orders)
       FAILED failed.

    result =
      VALUE #( FOR ls_order IN lt_orders
        ( %key = ls_order-%key
          %features-%action-set_status_conf = COND #( WHEN ls_order-status = 'C'
                                                        THEN if_abap_behv=>fc-o-disabled
                                                        ELSE if_abap_behv=>fc-o-enabled )
         ) ).


  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA : ls_order TYPE zjp_order.

    SELECT FROM zjp_order
         FIELDS : MAX(  ordernumber ) INTO @DATA(lv_order).
    IF sy-subrc EQ 0.
      lv_order = lv_order + 1.
    ELSE.
      lv_order = 1.
    ENDIF.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity_order>).

      ls_order = CORRESPONDING #( <lfs_entity_order> ).
      IF ls_order IS NOT INITIAL.
        ls_order-ordernumber = lv_order.

        "A number range can be called here
        lv_order += 1.
        IF ls_order-customer IS NOT INITIAL.
          zjp_order_core=>create_order( ls_order ).

          "Pass the key back
          mapped-order = VALUE #( BASE mapped-order
                                  ( %cid = <lfs_entity_order>-%cid
                                    ordernumber  = ls_order-ordernumber
                                  ) ).
          "Pass the success  messages
*        APPEND VALUE #( %msg = new_message( id       = '00'
*                                                      number   = '001'
*                                                      v1       = 'Order Created '
*                                                      v2      = ls_order-ordernumber
*                                                      severity = if_abap_behv_message=>severity-success )
*                                  %key-ordernumber = <lfs_entity_order>-ordernumber
*                                  %cid =  <lfs_entity_order>-%cid
*                                  ordernumber = <lfs_entity_order>-ordernumber )
*                                  TO reported-order.
        ELSE.
*          APPEND VALUE #( %cid = <lfs_entity_order>-%cid
*              %create =  if_abap_behv=>mk-on
*              "ordernumber = <lfs_entity_order>-ordernumber
*              )
*              TO failed-order.

*          APPEND VALUE #( %msg = new_message( id       = '00'
*                                                        number   = '001'
*                                                        v1       = 'Error in Order Create:Customer Number missing '
*                                                        v2      = ls_order-ordernumber
*                                                        severity = if_abap_behv_message=>severity-error )
*                                    "%key-ordernumber = <lfs_entity_order>-ordernumber
*                                    %cid =  <lfs_entity_order>-%cid
*                                     %create =  if_abap_behv=>mk-on
*                                    "ordernumber = <lfs_entity_order>-ordernumber
*                                    )
*                                    TO reported-order.
        ENDIF.
      ENDIF.

    ENDLOOP.



  ENDMETHOD.

  METHOD update.

    DATA : ls_order TYPE zjp_order.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity_order>).

      "Select existing data
      SELECT SINGLE * FROM zjp_order WHERE ordernumber = @<lfs_entity_order>-ordernumber
          INTO @DATA(ls_order_old).

      ls_order = VALUE #( ordernumber = <lfs_entity_order>-ordernumber
                                            ordertype       =  COND #(  WHEN  <lfs_entity_order>-%control-ordertype = if_abap_behv=>mk-on THEN <lfs_entity_order>-ordertype
                                                                                            ELSE   ls_order_old-ordertype  )
                                            salesorg       =  COND #(  WHEN  <lfs_entity_order>-%control-salesorg = if_abap_behv=>mk-on THEN <lfs_entity_order>-salesorg
                                                                                            ELSE   ls_order_old-salesorg  )
                                            distchannel       =  COND #(  WHEN  <lfs_entity_order>-%control-distchannel = if_abap_behv=>mk-on THEN <lfs_entity_order>-distchannel
                                                                                            ELSE   ls_order_old-distchannel  )
                                            division       =  COND #(  WHEN  <lfs_entity_order>-%control-division = if_abap_behv=>mk-on THEN <lfs_entity_order>-division
                                                                                            ELSE   ls_order_old-division  )
                                            customer       =  COND #(  WHEN  <lfs_entity_order>-%control-customer = if_abap_behv=>mk-on THEN <lfs_entity_order>-customer
                                                                                            ELSE   ls_order_old-customer  )
                                            grossamount       =  COND #(  WHEN  <lfs_entity_order>-%control-grossamount = if_abap_behv=>mk-on THEN <lfs_entity_order>-grossamount
                                                                                            ELSE   ls_order_old-grossamount  )
                                            currency       =  COND #(  WHEN  <lfs_entity_order>-%control-currency = if_abap_behv=>mk-on THEN <lfs_entity_order>-currency
                                                                                            ELSE   ls_order_old-currency  )
                                            status       =  COND #(  WHEN  <lfs_entity_order>-%control-status = if_abap_behv=>mk-on THEN <lfs_entity_order>-status
                                                                                            ELSE   ls_order_old-status  )
                                            locallastchangedat       =  COND #(  WHEN  <lfs_entity_order>-%control-locallastchangedat = if_abap_behv=>mk-on THEN <lfs_entity_order>-locallastchangedat
                                                                                            ELSE   ls_order_old-locallastchangedat  )
                                            lastchangedat       =  COND #(  WHEN  <lfs_entity_order>-%control-lastchangedat = if_abap_behv=>mk-on THEN <lfs_entity_order>-lastchangedat
                                                                                            ELSE   ls_order_old-lastchangedat  )
                                                                                                                                                                                        ).
      IF ls_order IS NOT INITIAL.

        zjp_order_core=>update_order( ls_order ).

        "Pass the success messages
*        APPEND VALUE #( %msg = new_message( id       = '00'
*                                                      number   = '001'
*                                                      v1       = 'Order Updated '
*                                                      v2      = ' '
*                                                      v3      = ls_order-ordernumber
*                                                      severity = if_abap_behv_message=>severity-success )
*                                  %key-ordernumber = <lfs_entity_order>-ordernumber
*                                  %cid =  <lfs_entity_order>-%cid_ref
*                                  ordernumber = <lfs_entity_order>-ordernumber )
*                                  TO reported-order.

*          APPEND VALUE #( %cid = <lfs_entity_order>-%cid_ref
*              ordernumber = <lfs_entity_order>-ordernumber )
*              TO failed-order.
*
*          APPEND VALUE #( %msg = new_message( id       = '00'
*                                                        number   = '001'
*                                                        v1       = 'Error in Order Update '
*                                                        v2      = ' '
*                                                        v3      = ls_order-ordernumber
*                                                        severity = if_abap_behv_message=>severity-success )
*                                    %key-ordernumber = <lfs_entity_order>-ordernumber
*                                    %cid =  <lfs_entity_order>-%cid_ref
*                                    ordernumber = <lfs_entity_order>-ordernumber )
*                                    TO reported-order.

      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD delete.

    DATA : ls_order TYPE zjp_order.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_del_keys>).
      ls_order = CORRESPONDING #( <lfs_del_keys>  ).
      IF ls_order IS NOT INITIAL.

        zjp_order_core=>delete_order( ls_order ).

*        APPEND VALUE #( %cid = <lfs_del_keys>-%cid_ref
*            ordernumber = <lfs_del_keys>-ordernumber )
*            TO failed-order.
*
*        APPEND VALUE #( %msg = new_message( id       = '00'
*                                                      number   = '001'
*                                                      v1       = 'Error in Order Delete'
*                                                      v2      = ls_order-ordernumber
*                                                      severity = if_abap_behv_message=>severity-error )
*                                  %key-ordernumber = <lfs_del_keys>-ordernumber
*                                  %cid =  <lfs_del_keys>-%cid_ref
*                                  ordernumber = <lfs_del_keys>-ordernumber )
*                                  TO reported-order.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD read.

    IF keys IS NOT INITIAL.
      SELECT * FROM zjp_order
      FOR ALL ENTRIES IN @keys
      WHERE ordernumber =  @keys-ordernumber
      INTO CORRESPONDING FIELDS OF TABLE @result.
    ENDIF.



  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_item.
  ENDMETHOD.

  METHOD cba_item.

    DATA : ls_item       TYPE zjp_item,
           lt_items      TYPE STANDARD TABLE OF zjp_item,
           lv_itemnumber TYPE  zjp_item-itemnumber.

    LOOP AT entities_cba ASSIGNING FIELD-SYMBOL(<lfs_entity_item>).

      IF lv_itemnumber IS INITIAL.
        SELECT FROM zjp_item FIELDS : MAX(  itemnumber )  WHERE ordernumber = @<lfs_entity_item>-ordernumber
        INTO @lv_itemnumber.
        IF sy-subrc EQ 0.
          lv_itemnumber = lv_itemnumber + 1.
        ELSE.
          lv_itemnumber = 1.
        ENDIF.
      ENDIF.

      LOOP AT <lfs_entity_item>-%target ASSIGNING FIELD-SYMBOL(<lfs_item>).

        ls_item = CORRESPONDING #( <lfs_item> ).
        ls_item-itemnumber = lv_itemnumber.
        lv_itemnumber = lv_itemnumber + 1.

        ls_item-ordernumber = <lfs_entity_item>-ordernumber.
        zjp_order_core=>create_item( ls_item ).

        mapped-item = VALUE #( BASE mapped-item
                                ( %cid = <lfs_entity_item>-%cid_ref
                                  ordernumber  = ls_item-ordernumber
                                  itemnumber = ls_item-itemnumber
                                ) ).

*        reported-item = VALUE #( BASE reported-item
*                                                          ( %msg = new_message( id       = '00'
*                                                              number   = '001'
*                                                              v1       = 'Order Item Created '
*                                                              v2      = ls_item-ordernumber
*                                                              v3      = ls_item-itemnumber
*                                                              severity = if_abap_behv_message=>severity-success )
*                                      %key-ordernumber = <lfs_entity_item>-ordernumber
*                                       %key-itemnumber = ls_item-itemnumber
*                                      %cid =  <lfs_entity_item>-%cid_ref
*                                      ordernumber = <lfs_entity_item>-ordernumber
*                                      itemnumber = ls_item-itemnumber  ) ).
*          APPEND VALUE #( %cid = <lfs_entity_item>-%cid_ref
*              ordernumber = <lfs_item>-ordernumber
*              itemnumber =  ls_item-itemnumber )
*              TO failed-item.


*          reported-item = VALUE #( BASE reported-item
*                                                            ( %msg = new_message( id       = '00'
*                                                                number   = '001'
*                                                                v1       = 'Error in Order Item Create '
*                                                                v2      = ls_item-ordernumber
*                                                                v3      = ls_item-itemnumber
*                                                                severity = if_abap_behv_message=>severity-success )
*                                        %key-ordernumber = <lfs_entity_item>-ordernumber
*                                         %key-itemnumber = ls_item-itemnumber
*                                        %cid =  <lfs_entity_item>-%cid_ref
*                                        ordernumber = <lfs_entity_item>-ordernumber
*                                        itemnumber = ls_item-itemnumber  ) ).

      ENDLOOP.
    ENDLOOP.


  ENDMETHOD.

  METHOD set_status_conf.

    MODIFY ENTITIES OF zjp_i_order IN LOCAL MODE
       ENTITY order
          UPDATE FROM VALUE #(
          FOR key IN keys
          ( ordernumber = key-ordernumber
            status = 'C' "Confirmed
            %control-status = if_abap_behv=>mk-on ) )
          FAILED failed
          REPORTED reported.

    "Read changed data for action result
    READ ENTITIES OF zjp_i_order IN LOCAL MODE
      ENTITY order
      ALL FIELDS WITH
      CORRESPONDING #( keys )
      RESULT DATA(orders).

    result = VALUE #( FOR order IN orders
             ( %tky   = order-%tky
               %param = order ) ).

    APPEND VALUE #( %msg = new_message( id       = '00'
                                                  number   = '001'
                                                  v1       = 'Order Confirmed '
                                                  severity = if_abap_behv_message=>severity-success ) )
                              TO reported-order.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE item.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE item.

    METHODS read FOR READ
      IMPORTING keys FOR READ item RESULT result.

    METHODS rba_order FOR READ
      IMPORTING keys_rba FOR READ item\_order FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD update.

    DATA : ls_item TYPE zjp_item.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<lfs_entity>).

      ls_item = CORRESPONDING #( <lfs_entity>  ) .   "MAPPING FROM ENTITY
      IF ls_item IS NOT INITIAL.

        zjp_order_core=>update_item( ls_item ).

        "Pass the success messages
*        APPEND VALUE #( %msg = new_message( id       = '00'
*                                                      number   = '001'
*                                                      v1       = 'Order Updated '
*                                                      v2      = ' '
*                                                      v3      = ls_item-ordernumber
*                                                      v4      = ls_item-itemnumber
*                                                      severity = if_abap_behv_message=>severity-success )
*                                  %key-ordernumber = <lfs_entity>-ordernumber
*                                  %cid =  <lfs_entity>-%cid_ref
*                                  ordernumber = <lfs_entity>-ordernumber
*                                  itemnumber =  <lfs_entity>-Itemnumber )
*                                  TO reported-item.

      ENDIF.
    ENDLOOP.



  ENDMETHOD.

  METHOD delete.

    DATA : ls_item TYPE zjp_item.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_del_keys>).
      ls_item = CORRESPONDING #( <lfs_del_keys>  ).
      IF ls_item IS NOT INITIAL.

        zjp_order_core=>delete_item( ls_item ).
        "Pass the success messages
*        APPEND VALUE #( %msg = new_message( id       = '00'
*                                                      number   = '001'
*                                                      v1       = 'Order Item Deleted '
*                                                      v2      = ls_item-ordernumber
*                                                       v3      = ls_item-itemnumber
*                                                      severity = if_abap_behv_message=>severity-success )
*                                  %key-ordernumber = <lfs_del_keys>-ordernumber
*                                  %cid =  <lfs_del_keys>-%cid_ref
*                                  ordernumber = <lfs_del_keys>-ordernumber )
*                                  TO reported-item.

      ENDIF.
    ENDLOOP.



  ENDMETHOD.

  METHOD read.

    IF keys IS NOT INITIAL.
      SELECT * FROM zjp_item
      FOR ALL ENTRIES IN @keys
      WHERE ordernumber =  @keys-ordernumber
      AND itemnumber = @keys-itemnumber
      INTO CORRESPONDING FIELDS OF TABLE @result.
    ENDIF.


  ENDMETHOD.

  METHOD rba_order.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zjp_i_order DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zjp_i_order IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA(lv_flag) = zjp_order_core=>save_orders(  ).

*    IF lv_flag = 'S'.
*
*      APPEND VALUE #( %msg = new_message( id       = '00'
*                                                    number   = '001'
*                                                    v1       = 'Data saved'
*                                                    severity = if_abap_behv_message=>severity-success ) )
*                                TO reported-order.
*    ELSEIF lv_flag = 'E'.
*      APPEND VALUE #( %msg = new_message( id       = '00'
*                                                    number   = '001'
*                                                    v1       = 'Error in Save '
*                                                    severity = if_abap_behv_message=>severity-error ) )
*                                TO reported-order.
*
*    ENDIF.


  ENDMETHOD.

  METHOD cleanup.

    zjp_order_core=>cleanup_orders(  ).

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
