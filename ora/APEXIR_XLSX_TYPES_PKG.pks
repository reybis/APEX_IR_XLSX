CREATE OR REPLACE PACKAGE "APEXIR_XLSX_TYPES_PKG" 
  AUTHID DEFINER
AS 

  TYPE t_apex_ir_highlight IS RECORD
    ( bg_color apex_application_page_ir_cond.highlight_row_color%TYPE
    , font_color apex_application_page_ir_cond.highlight_row_font_color%TYPE
    , highlight_name apex_application_page_ir_cond.condition_name%TYPE
    , highlight_sql apex_application_page_ir_cond.condition_sql%TYPE
    , col_num NUMBER -- defines which SQL column to check
    , affected_column VARCHAR2(30)
    )
  ;
  
  TYPE t_apex_ir_highlights IS TABLE OF t_apex_ir_highlight INDEX BY VARCHAR2(30);
  TYPE t_apex_ir_active_hl IS TABLE OF t_apex_ir_highlight INDEX BY PLS_INTEGER;

  -- Types to hold run-time information
  TYPE t_apex_ir_col IS RECORD
    ( report_label apex_application_page_ir_col.report_label%TYPE
    , is_visible BOOLEAN
    , is_break_col BOOLEAN
    , sum_on_break BOOLEAN
    , avg_on_break BOOLEAN
    , max_on_break BOOLEAN
    , min_on_break BOOLEAN
    , median_on_break BOOLEAN
    , count_on_break BOOLEAN
    , count_distinct_on_break BOOLEAN
    , highlight_conds t_apex_ir_highlights
    , sql_col_num NUMBER -- defines which SQL column to check
    , display_column PLS_INTEGER
    )
  ;
  
  TYPE t_apex_ir_cols IS TABLE OF t_apex_ir_col INDEX BY VARCHAR2(30);

  TYPE t_apex_ir_info IS RECORD
    ( application_id NUMBER -- Application ID IR belongs to
    , page_id NUMBER -- Page ID IR belongs to
    , region_id NUMBER -- Region ID of IR Region
    , session_id NUMBER -- Session ID for Request
    , base_report_id NUMBER -- Report ID for Request
    , report_title VARCHAR2(4000) -- Derived Report Title
    , report_definition apex_ir.t_report -- Collected using APEX function APEX_IR.GET_REPORT
    , final_sql VARCHAR2(32767)
    )
  ;

  TYPE t_xlsx_options IS RECORD
    ( show_title BOOLEAN -- Show header line with report title
    , show_filters BOOLEAN -- show header lines with filter settings
    , show_column_headers BOOLEAN -- show column headers before data
    , process_highlights BOOLEAN -- format data according to highlights
    , show_highlights BOOLEAN -- show header lines with highlight settings, not useful if set without above
    , show_aggregates BOOLEAN -- process aggregates and show on total lines
    , display_column_count NUMBER -- holds the count of displayed columns, used for merged cells in header section
    , sheet PLS_INTEGER -- holds the worksheet reference
    , default_font VARCHAR2(100)
    , default_border_color VARCHAR2(100)
    )
  ;
  
  TYPE t_sql_col_info IS RECORD
    ( col_name VARCHAR2(32767)
    , col_data_type VARCHAR2(30)
    , col_type VARCHAR2(30)
    , is_displayed BOOLEAN := FALSE -- assume no display, we loop through all and flag displayed then
    );
  
  TYPE t_sql_col_infos IS TABLE OF t_sql_col_info INDEX BY PLS_INTEGER;
  
  TYPE t_cursor_info IS RECORD
    ( cursor_id PLS_INTEGER
    , column_count PLS_INTEGER
    , date_tab dbms_sql.date_table
    , num_tab dbms_sql.number_table
    , vc_tab dbms_sql.varchar2_table
    );

END APEXIR_XLSX_TYPES_PKG;
/