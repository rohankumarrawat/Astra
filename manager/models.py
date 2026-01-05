from django.db import models
from django.contrib.auth.models import User

class Department(models.Model):
    STATUS_CHOICES = [
        ('Active', 'Active'),
        ('Inactive', 'Inactive'),
    ]

    name = models.CharField(max_length=100, unique=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Active')

    def __str__(self):
        return self.name
    

class Grade(models.Model):
    STATUS_CHOICES = [
        ('Active', 'Active'),
        ('Inactive', 'Inactive'),
    ]
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Active')
    name = models.CharField(max_length=100, unique=True)
    

    def __str__(self):
        return self.name
    
class Role(models.Model):
    name = models.CharField(max_length=100, unique=True)  # Optional: make role names unique

    def __str__(self):
        return self.name


class Permission(models.Model):
    name = models.CharField(max_length=100, unique=True)  # Prevent duplicate permissions globally

    def __str__(self):
        return self.name


class RolePermission(models.Model):
    role = models.ForeignKey(Role, on_delete=models.CASCADE, related_name="role_permissions")
    permission = models.ForeignKey(Permission, on_delete=models.CASCADE, related_name="permission_roles")

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['role', 'permission'], name='unique_role_permission')
        ]

    def __str__(self):
        return f"{self.role.name} → {self.permission.name}"

    
class Position(models.Model):
    STATUS_CHOICES = [
        ('Active', 'Active'),
        ('Inactive', 'Inactive'),
    ]

    name = models.CharField(max_length=100, unique=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Active')

    def __str__(self):
        return self.name
    

class ShiftType(models.Model):
    STATUS_CHOICES = [
        ('Active', 'Active'),
        ('Inactive', 'Inactive'),
    ]

    name = models.CharField(max_length=100, unique=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Active')

    def __str__(self):
        return self.name



class Designation(models.Model):
    name = models.CharField(max_length=100)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name="designations")
    status = models.CharField(
        max_length=10,
        choices=[("Active", "Active"), ("Inactive", "Inactive")],
        default="Active"
    )

    def employee_count(self):
        return self.employees.count() if hasattr(self, "employees") else 0

    def __str__(self):
        return f"{self.name} ({self.department.name})"

class Employee(models.Model):
    EMPLOYEE_TYPE_CHOICES = [
        ('monthly', 'Monthly Employee'),
        ('daily', 'Daily Worker'),
    ]
    GENDER_CHOICES = [
        ('male', 'Male'),
        ('female', 'Female'),
        ('other', 'Other'),
    ]
    MARITAL_CHOICES = [
        ('single', 'Single'),
        ('married', 'Married'),
    ]

    # Common fields
    STATUS_CHOICES = [
        ('Active', 'Active'),
        ('Inactive', 'Inactive'),
    ]
    user = models.OneToOneField(User, on_delete=models.CASCADE, null=True, blank=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Active')
    employee_type = models.CharField(max_length=10, choices=EMPLOYEE_TYPE_CHOICES, default='daily')
    profile = models.ImageField(upload_to='profiles/', blank=True, null=True)
    name = models.CharField(max_length=150)
    phone = models.CharField(max_length=20)
    joining_date = models.DateField(null=True,blank=True)
    emergency_number = models.CharField(max_length=20, blank=True, null=True)
    bank_name = models.CharField(max_length=100, blank=True, null=True)
    account_number = models.CharField(max_length=50, blank=True, null=True)
    pan_number = models.CharField(max_length=20, blank=True, null=True)
    aadhar_front = models.ImageField(upload_to='aadhar/', blank=True, null=True)
    aadhar_back = models.ImageField(upload_to='aadhar/', blank=True, null=True)
    department = models.ForeignKey(Department, on_delete=models.CASCADE, related_name="employee")
    role = models.ForeignKey(Role, on_delete=models.CASCADE, related_name="employees", null=True, blank=True)
    under = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True, related_name='employee_under')

    

    # Monthly employee specific
    email = models.EmailField(blank=True, null=True)
    password = models.CharField(max_length=128, blank=True, null=True)
    ifsc_number = models.CharField(max_length=20, blank=True, null=True)
    
    nationality = models.CharField(max_length=50, blank=True, null=True)
    religion = models.CharField(max_length=50, blank=True, null=True)
    marital_status = models.CharField(max_length=10, choices=MARITAL_CHOICES, blank=True, null=True)
    birthday = models.DateField(blank=True, null=True)
    gender = models.CharField(max_length=10, choices=GENDER_CHOICES, blank=True, null=True)
    
    position = models.ForeignKey(Position, on_delete=models.CASCADE, related_name="employee" ,  null=True,
    blank=True)
    designation = models.ForeignKey(
    Designation,
    on_delete=models.CASCADE,
    related_name="employee",
    null=True,
    blank=True
)
    grade = models.ForeignKey(Grade, on_delete=models.CASCADE, related_name="employee",  null=True,
    blank=True)
    
    description = models.TextField(blank=True, null=True)

    # Daily worker specific

    monthly_salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    pf_fund = models.CharField(max_length=50, blank=True, null=True)
    pf_number = models.CharField(max_length=50, blank=True, null=True)
    esi_number = models.CharField(max_length=50, blank=True, null=True)
    leaves = models.PositiveIntegerField(default=0)
    bonus = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    professional_tax = models.DecimalField(max_digits=10, decimal_places=2, default=0,blank=True,null=True)
    labour_tax = models.DecimalField(max_digits=10, decimal_places=2, default=0,blank=True,null=True)
    uan_number = models.CharField(max_length=50, blank=True, null=True)
    weekly_off = models.CharField(max_length=20, blank=True, null=True)
    daily_salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    worker_type = models.CharField(max_length=50, blank=True, null=True)
    assign_location = models.CharField(max_length=100, blank=True, null=True)


    hra = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    conveyance = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    special = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    ta = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)  # Travel Allowance
    da = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)  # Dearness Allowance
    epfo = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    esic = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    insurance = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    pt = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)  # Professional Tax

    # Document Uploads
    pan_image = models.ImageField(upload_to='documents/pan/', blank=True, null=True)
    bank_passbook = models.ImageField(upload_to='documents/passbook/', blank=True, null=True)
    character_certificate = models.ImageField(upload_to='documents/character_certificate/', blank=True, null=True)
    def save(self, *args, **kwargs):
        if not self.name:
            try:
                self.name = User.objects.get(username='rohan')
            except User.DoesNotExist:
                pass  # Or handle error appropriately
        super().save(*args, **kwargs)
    

    def __str__(self):
        return self.name


class Holiday(models.Model):
    STATUS_CHOICES = (
        ('Active', 'Active'),
        ('Inactive', 'Inactive'),
    )

    title = models.CharField(max_length=255)
    date = models.DateField()
    description = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Active')

    def __str__(self):
        return self.title
    

class Leave(models.Model):
    STATUS_CHOICES = (
        ('Active', 'Active'),
        ('Inactive', 'Inactive'),
    )
    name = models.CharField(max_length=100)
    description = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='Active')

    def __str__(self):
        return self.name
    


class Shift(models.Model):
    SHIFT_TYPE_CHOICES = (
        ('Day', 'Day'),
        ('Night', 'Night'),
        ('Custom', 'Custom'),
    )

    name = models.CharField(max_length=100, unique=True)
    start_time = models.TimeField()
    end_time = models.TimeField()
    break_duration = models.DurationField(default=0)  # optional
    shift_type = models.CharField(max_length=20, choices=SHIFT_TYPE_CHOICES, default='Day')
    is_active = models.BooleanField(default=True)

    def __str__(self):
        return self.name

    def total_work_duration(self):
        """
        Returns net shift duration excluding break
        """
        import datetime
        start = datetime.datetime.combine(datetime.date.today(), self.start_time)
        end = datetime.datetime.combine(datetime.date.today(), self.end_time)
        if end <= start:
            end += datetime.timedelta(days=1)  # Handle overnight shift
        duration = end - start - self.break_duration
        return duration
    

class Schedule(models.Model):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE)
    shift = models.ForeignKey(Shift, on_delete=models.CASCADE,blank=True,null=True)

class Attendance(models.Model):
    ATTENDANCE_TYPE_CHOICES = [
        ("Full Day", "Full Day"),
        ("Half Day", "Half Day"),
        ("Late", "Late"),
        ("Absent", "Absent"),
    ]

    employee = models.ForeignKey(Employee, on_delete=models.CASCADE)
    date = models.DateField()
    check_in = models.TimeField(null=True, blank=True)
    check_out = models.TimeField(null=True, blank=True)
    remarks = models.TextField(blank=True)
    type = models.CharField(max_length=20, choices=ATTENDANCE_TYPE_CHOICES, blank=True)

    class Meta:
        unique_together = ('employee', 'date')  # Only one record per employee/day

    def __str__(self):
        return f"{self.employee.name} - {self.date}"



class LeaveApplication(models.Model):
    DURATION_CHOICES = (
        ('full', 'Full Day'),
        ('half', 'Half Day'),
    )
    HALF_TYPE_CHOICES = (
        ('first', 'First Half'),
        ('second', 'Second Half'),
    )

    employee = models.ForeignKey('Employee', on_delete=models.CASCADE)
    leave_type = models.ForeignKey('Leave', on_delete=models.SET_NULL, null=True)
    duration_type = models.CharField(max_length=10, choices=DURATION_CHOICES)
    from_date = models.DateField(null=True, blank=True)
    to_date = models.DateField(null=True, blank=True)
    half_day_date = models.DateField(null=True, blank=True)
    half_type = models.CharField(max_length=10, choices=HALF_TYPE_CHOICES, blank=True, null=True)
    attachment = models.FileField(upload_to='leave_attachments/', blank=True, null=True)
    reason = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    superadmin_approval=models.BooleanField(default=False)
    admin_approval=models.BooleanField(default=False)
    admin_approved_on = models.DateField(null=True, blank=True)
    superadmin_approved_on = models.DateField(null=True, blank=True)
    superadmin_cancelled=models.BooleanField(default=False)
    admin_cancelled=models.BooleanField(default=False)

    def __str__(self):
        return f"{self.employee} - {self.leave_type}"
    


class AdvanceSalaryApplication(models.Model):
    REPAYMENT_METHOD_CHOICES = (
        ('single', 'Single Installment'),
        ('emi', 'Monthly EMI'),
    )

    employee = models.ForeignKey('Employee', on_delete=models.CASCADE)
    amount_requested = models.DecimalField(max_digits=10, decimal_places=2)
    salary_month = models.DateField(help_text="Month for which advance is requested")
    repayment_method = models.CharField(max_length=10, choices=REPAYMENT_METHOD_CHOICES)
    emi_months = models.PositiveIntegerField(null=True, blank=True, help_text="Applicable only if EMI selected")

    reason = models.TextField()
    attachment = models.FileField(upload_to='advance_salary_attachments/', blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)
    
    # Approval Workflow
    superadmin_approval = models.BooleanField(default=False)
    admin_approval = models.BooleanField(default=False)
    admin_approved_on = models.DateField(null=True, blank=True)
    superadmin_approved_on = models.DateField(null=True, blank=True)

    superadmin_cancelled = models.BooleanField(default=False)
    admin_cancelled = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.employee} - {self.amount_requested}"


class Salary(models.Model):
    SALARY_TYPE_CHOICES = [
        ('monthly', 'Monthly Salary'),
        ('daily', 'Daily Wage'),
    ]

    employee = models.OneToOneField(Employee, on_delete=models.CASCADE, related_name="salary")
    salary_type = models.CharField(max_length=10, choices=SALARY_TYPE_CHOICES)

    # Base salary fields
    basic_salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    daily_salary = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    # Allowances
    hra = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    conveyance = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    special_allowance = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    ta = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    da = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    # Deductions
    pf = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    esi = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    insurance = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    professional_tax = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    labour_tax = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)

    # Misc fields
    bonus = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    leaves_allowed = models.PositiveIntegerField(default=0)
    weekly_off = models.CharField(max_length=20, blank=True, null=True)

    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Salary for {self.employee.name}"


class MonthlySalary(models.Model):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE)
    month = models.IntegerField()   # 1 - 12
    year = models.IntegerField()    # 2025 etc
    total_working_days = models.IntegerField(default=0)
    present_days = models.IntegerField(default=0)
    half_days = models.IntegerField(default=0)
    absent_days = models.IntegerField(default=0)
    paid_leave_used = models.IntegerField(default=0)
    unpaid_leave = models.IntegerField(default=0)

    gross_salary = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    deductions = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    net_salary = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    loan_deduction_total = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('employee', 'month', 'year')

    def __str__(self):
        return f"{self.employee.name} Salary {self.month}-{self.year}"
