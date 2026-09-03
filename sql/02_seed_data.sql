-- 02_seed_data.sql
-- Datos iniciales de prueba

INSERT INTO departments (department_name, budget) VALUES
('Engineering', 150000.00),
('Data & Analytics', 120000.00),
('Finance', 90000.00),
('Human Resources', 60000.00);

INSERT INTO job_titles (title_name, base_salary) VALUES
('Senior Data Engineer', 5500.00),
('Data Analyst', 3800.00),
('Software Engineer', 4800.00),
('Financial Analyst', 3500.00),
('HR Specialist', 2800.00);

INSERT INTO employees (first_name, last_name, email, department_id, title_id, hire_date, is_active) VALUES
('José', 'García', 'jose.garcia@company.com', 2, 1, '2024-01-15', TRUE),
('Carlos', 'Mendoza', 'carlos.mendoza@company.com', 2, 2, '2024-03-01', TRUE),
('Ana', 'Ríos', 'ana.rios@company.com', 1, 3, '2023-06-10', TRUE),
('María', 'Torres', 'maria.torres@company.com', 3, 4, '2022-11-20', TRUE),
('Luis', 'Gómez', 'luis.gomez@company.com', 4, 5, '2025-02-01', FALSE);