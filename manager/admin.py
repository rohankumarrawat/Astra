from django.contrib import admin

# Register your models here.
from .models import Employee,Department,Role,Permission,RolePermission,Attendance,LeaveApplication,AdvanceSalaryApplication,Salary,MonthlySalary
admin.site.register(Employee)
admin.site.register(Department)
admin.site.register(Role)
admin.site.register(Permission)
admin.site.register(RolePermission)
admin.site.register(Attendance)
admin.site.register(LeaveApplication)
admin.site.register(AdvanceSalaryApplication)
admin.site.register(Salary)
admin.site.register(MonthlySalary)