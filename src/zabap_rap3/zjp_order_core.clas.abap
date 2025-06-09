CLASS zjp_order_core DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES : if_oo_adt_classrun.

    TYPES : tt_orders TYPE STANDARD TABLE OF zjp_order WITH DEFAULT KEY,
            tt_items  TYPE STANDARD TABLE OF zjp_item WITH DEFAULT KEY.


    "Create
    CLASS-DATA : orders_create TYPE tt_orders,
                 items_create  TYPE tt_items,
                 orders_update TYPE tt_orders,
                 items_update  TYPE tt_items,
                 orders_delete TYPE tt_orders,
                 items_delete  TYPE tt_items.

    CLASS-METHODS : create_order IMPORTING is_order      TYPE zjp_order,
      update_order IMPORTING is_order      TYPE zjp_order,
      delete_order IMPORTING is_order      TYPE zjp_order,
      create_item IMPORTING is_item       TYPE  zjp_item,
      update_item IMPORTING is_item       TYPE  zjp_item,
      delete_item IMPORTING is_item       TYPE  zjp_item,

      save_orders RETURNING VALUE(lv_flag) TYPE abap_boolean,  "Just using 2 char data
      cleanup_orders.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zjp_order_core IMPLEMENTATION.

  METHOD create_order.
APPEND is_order TO orders_create.
  ENDMETHOD.

  METHOD update_order.
    APPEND is_order TO orders_update.
  ENDMETHOD.

  METHOD create_item.
    APPEND is_item TO items_create.
  ENDMETHOD.

  METHOD delete_item.
    APPEND is_item TO items_delete..
  ENDMETHOD.

  METHOD delete_order.
    APPEND is_order TO orders_delete.
  ENDMETHOD.

  METHOD update_item.
    APPEND is_item TO items_update.
  ENDMETHOD.

  METHOD save_orders.

    CLEAR lv_flag.
    IF orders_create IS NOT INITIAL OR
         orders_update IS NOT INITIAL OR
         orders_delete IS NOT INITIAL OR
         items_create IS NOT INITIAL OR
         items_update  IS NOT INITIAL OR
         items_update  IS NOT INITIAL.

      lv_flag = 'S'.
    ENDIF.

    IF orders_create IS NOT INITIAL.

      INSERT zjp_order FROM TABLE @orders_create.
      IF sy-subrc EQ 0.
        IF items_create IS NOT INITIAL.
          INSERT zjp_item FROM TABLE @items_create.
        ENDIF.
      ENDIF.
    ELSEIF items_create IS NOT INITIAL.
      INSERT zjp_item FROM TABLE @items_create.
    ENDIF.

    IF orders_update IS NOT INITIAL.
      UPDATE zjp_order FROM TABLE @orders_update .
      IF sy-subrc EQ 0.
        IF items_update IS NOT INITIAL.
          UPDATE zjp_item FROM TABLE @items_update .
        ENDIF.
      ENDIF.
    ELSEIF items_update IS NOT INITIAL.
      UPDATE zjp_item FROM TABLE @items_update .
    ENDIF.

    IF orders_delete IS NOT INITIAL.

      LOOP AT orders_delete INTO DATA(ls_order).
        SELECT SINGLE FROM zjp_order FIELDS : status
            WHERE ordernumber = @ls_order-ordernumber
            INTO @DATA(lv_status).
          DELETE FROM zjp_order WHERE ordernumber = @ls_order-ordernumber.
          IF sy-subrc EQ 0.
            DELETE FROM zjp_item WHERE ordernumber = @ls_order-ordernumber.
          ENDIF.
      ENDLOOP.
    ENDIF.

    LOOP AT items_delete INTO DATA(ls_item).
      DELETE FROM zjp_item WHERE ordernumber = @ls_item-ordernumber
                                                    AND     itemnumber = @ls_item-itemnumber.
    ENDLOOP.

  ENDMETHOD.

  METHOD cleanup_orders.

    CLEAR : orders_create, orders_update, orders_delete, items_create, items_update, items_delete.

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
        DELETE FROM zjp_item_d.
        DELETE FROM zjp_item.
        DELETE FROM zjp_order_d.
        DELETE FROM zjp_order.
  ENDMETHOD.

ENDCLASS.


