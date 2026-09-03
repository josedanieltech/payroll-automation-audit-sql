-- 03_stored_procedures.sql
-- Procedimiento almacenado para automatizar la ejecución de nómina

CREATE OR REPLACE PROCEDURE process_payroll(
    p_start_date DATE,
    p_end_date DATE,
    p_bonus_percentage NUMERIC DEFAULT 0.05
)
LANGUAGE plpgsql
AS $$
DECLARE
    emp RECORD;
    v_gross NUMERIC(10, 2);
    v_bonus NUMERIC(10, 2);
    v_tax NUMERIC(10, 2);
    v_processed_count INT := 0;
BEGIN
    FOR emp IN 
        SELECT e.employee_id, jt.base_salary
        FROM employees e
        JOIN job_titles jt ON e.title_id = jt.title_id
        WHERE e.is_active = TRUE
    LOOP
        v_gross := emp.base_salary;
        v_bonus := v_gross * p_bonus_percentage;
        v_tax := (v_gross + v_bonus) * 0.15; -- 15% Impuesto/Deducción

        INSERT INTO payroll_records (
            employee_id, 
            pay_period_start, 
            pay_period_end, 
            gross_salary, 
            bonus, 
            tax_deduction
        )
        VALUES (
            emp.employee_id, 
            p_start_date, 
            p_end_date, 
            v_gross, 
            v_bonus, 
            v_tax
        )
        ON CONFLICT (employee_id, pay_period_start, pay_period_end) 
        DO UPDATE SET
            gross_salary = EXCLUDED.gross_salary,
            bonus = EXCLUDED.bonus,
            tax_deduction = EXCLUDED.tax_deduction,
            processed_at = CURRENT_TIMESTAMP;

        v_processed_count := v_processed_count + 1;
    END LOOP;

    RAISE NOTICE 'Nómina procesada exitosamente para % empleados activos.', v_processed_count;
END;
$$;