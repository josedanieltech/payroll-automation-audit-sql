-- 04_views_analytics.sql
-- Vistas analíticas y auditoría de variaciones salariales

-- Vista 1: Análisis de Nómina Consolidada y Variación respecto al Mes Anterior
CREATE OR REPLACE VIEW vw_monthly_payroll_comparison AS
WITH monthly_summary AS (
    SELECT 
        DATE_TRUNC('month', pay_period_start)::DATE AS pay_month,
        e.department_id,
        d.department_name,
        SUM(p.net_salary) AS total_net_payout,
        COUNT(p.payroll_id) AS total_employees
    FROM payroll_records p
    JOIN employees e ON p.employee_id = e.employee_id
    JOIN departments d ON e.department_id = d.department_id
    GROUP BY DATE_TRUNC('month', pay_period_start), e.department_id, d.department_name
)
SELECT 
    pay_month,
    department_name,
    total_net_payout,
    total_employees,
    LAG(total_net_payout, 1) OVER (
        PARTITION BY department_id 
        ORDER BY pay_month
    ) AS previous_month_payout,
    ROUND(
        (total_net_payout - LAG(total_net_payout, 1) OVER (PARTITION BY department_id ORDER BY pay_month)) 
        / NULLIF(LAG(total_net_payout, 1) OVER (PARTITION BY department_id ORDER BY pay_month), 0) * 100, 2
    ) AS mom_growth_percentage
FROM monthly_summary;

-- Vista 2: Ejecución Presupuestaria por Departamento (Presupuesto vs Gasto Real)
CREATE OR REPLACE VIEW vw_budget_execution AS
SELECT 
    d.department_name,
    d.budget AS total_budget,
    COALESCE(SUM(p.net_salary), 0) AS total_spent,
    (d.budget - COALESCE(SUM(p.net_salary), 0)) AS remaining_budget,
    ROUND(COALESCE(SUM(p.net_salary), 0) / d.budget * 100, 2) AS budget_utilization_pct
FROM departments d
LEFT JOIN employees e ON d.department_id = e.department_id
LEFT JOIN payroll_records p ON e.employee_id = p.employee_id
GROUP BY d.department_id, d.department_name, d.budget;