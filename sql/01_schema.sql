-- 01_schema.sql
-- Creación de Tablas para el Sistema de Automación de Nómina y Auditoría

DROP TABLE IF EXISTS payroll_audit_log CASCADE;
DROP TABLE IF EXISTS payroll_records CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS job_titles CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- 1. Tabla de Departamentos
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    budget NUMERIC(12, 2) NOT NULL CHECK (budget >= 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabla de Cargos / Puestos
CREATE TABLE job_titles (
    title_id SERIAL PRIMARY KEY,
    title_name VARCHAR(100) NOT NULL UNIQUE,
    base_salary NUMERIC(10, 2) NOT NULL CHECK (base_salary > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Tabla de Empleados
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    department_id INT NOT NULL REFERENCES departments(department_id),
    title_id INT NOT NULL REFERENCES job_titles(title_id),
    hire_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Registros de Nómina Procesados
CREATE TABLE payroll_records (
    payroll_id SERIAL PRIMARY KEY,
    employee_id INT NOT NULL REFERENCES employees(employee_id),
    pay_period_start DATE NOT NULL,
    pay_period_end DATE NOT NULL,
    gross_salary NUMERIC(10, 2) NOT NULL,
    bonus NUMERIC(10, 2) DEFAULT 0.00 CHECK (bonus >= 0),
    tax_deduction NUMERIC(10, 2) NOT NULL CHECK (tax_deduction >= 0),
    net_salary NUMERIC(10, 2) GENERATED ALWAYS AS (gross_salary + bonus - tax_deduction) STORED,
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_employee_period UNIQUE (employee_id, pay_period_start, pay_period_end)
);

-- 5. Tabla de Auditoría Financiera
CREATE TABLE payroll_audit_log (
    audit_id SERIAL PRIMARY KEY,
    payroll_id INT REFERENCES payroll_records(payroll_id) ON DELETE SET NULL,
    employee_id INT NOT NULL,
    action_type VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
    old_net_salary NUMERIC(10, 2),
    new_net_salary NUMERIC(10, 2),
    changed_by VARCHAR(100) DEFAULT CURRENT_USER,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
);