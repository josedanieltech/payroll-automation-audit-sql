-- 05_triggers_audit.sql
-- Trigger para registrar cambios o ajustes salariales en la tabla de auditoría

CREATE OR REPLACE FUNCTION log_payroll_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF (TG_OP = 'UPDATE') THEN
        IF OLD.net_salary <> NEW.net_salary THEN
            INSERT INTO payroll_audit_log (
                payroll_id,
                employee_id,
                action_type,
                old_net_salary,
                new_net_salary,
                notes
            )
            VALUES (
                NEW.payroll_id,
                NEW.employee_id,
                'UPDATE',
                OLD.net_salary,
                NEW.net_salary,
                CONCAT('Ajuste de sueldo neto detectado en el período: ', NEW.pay_period_start)
            );
        END IF;
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_payroll_audit
AFTER UPDATE ON payroll_records
FOR EACH ROW
EXECUTE FUNCTION log_payroll_changes();