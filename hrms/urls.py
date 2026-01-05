"""
URL configuration for hrms project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from . import views
from django.conf import settings
from django.conf.urls.static import static

urlpatterns = [
    path('admin/', admin.site.urls),
        path("ajax-login/", views.ajax_login, name="login"),
         path("departments/export/pdf/", views.export_departments_pdf, name="export_departments_pdf"),
    path("departments/export/excel/", views.export_departments_excel, name="export_departments_excel"),

            path("departments/edit/", views.edit_department, name="edit_department"),
              path("geneartedsalaryslip/<int:data>/", views.geneartedsalaryslip, name="geneartedsalaryslip"),
                path("departments/delete/", views.delete_department, name="delete_department"),
                   path("add_leave/", views.add_leave, name="add_leave"),
                   path('delete-leave/<int:leave_id>/', views.delete_leave, name='delete_leave'),

                   path('payslipview/<int:data>/', views.payslipview, name='payslipview'),
path("employee/update/<int:id>/", views.update_employee, name="update_employee"),
path('employee/<int:id>/update-basic-info/', views.update_basic_info, name='update_basic_info'),

 path("employee/update-personal-info/<int:id>/", views.update_personal_info, name="update_personal_info"),

path("employee/update-emergency/<int:id>/", views.update_emergency, name="update_emergency"),

path("employee/update-description/<int:id>/",
     views.update_description, name="update_description"),
         path('change-password/<str:data>/', views.change_password, name='change_password'),

     


path('toggle-leave-status/<int:leave_id>/', views.toggle_leave_status, name='toggle_leave_status'),

          path("add-department/", views.add_department, name="add_department"),
           path("logout/", views.ajax_logout, name="logout"),
            path("add-employee/", views.add_employee, name="add_employee"),

              path("designations/add/", views.add_designation, name="add_designation"),
    path("designations/edit/", views.edit_designation, name="edit_designation"),
    path("designations/delete/<int:pk>/", views.delete_designation, name="delete_designation"),
    path("designations/export/excel/", views.export_designations_excel, name="export_designations_excel"),
    path("designations/export/pdf/", views.export_designations_pdf, name="export_designations_pdf"),

    path("employee/update-bank-info/<int:id>/",
     views.update_bank_info, name="update_bank_info"),


path("employee/update-aadhar/<int:id>/",
     views.update_aadhar, name="update_aadhar"),


path("employee/update-salary/<int:id>/", views.update_salary, name="update_salary"),




               path('grade/', views.grade),
            path("grade/edit/", views.edit_grade, name="edit_grade"),
                path("grade/delete/", views.delete_grade, name="delete_grade"),
                    path('add-schedule/', views.add_schedule, name='add_schedule'),
          path("add-grade/", views.add_grade, name="add_grade"),

             path('shiftlist/', views.shiftlist),
              path('add-shift/', views.add_shift, name='add_shift'),

path('update-shift/', views.update_shift, name='update_shift'),
 path('delete-shift/', views.delete_shift, name='delete_shift'),
         path("grades/export/pdf/", views.export_grades_pdf, name="export_grade_pdf"),
    path("grades/export/excel/", views.export_grades_excel, name="export_grade_excel"),



               path('position/', views.position),
            path("position/edit/", views.edit_position, name="edit_position"),
                path("position/delete/", views.delete_position, name="delete_position"),
          path("add-position/", views.add_position, name="add_position"),





               path('shifttype/', views.shifttype),
            path("shifttype/edit/", views.edit_shifttype, name="edit_shifttype"),
                path("shifttype/delete/", views.delete_shifttype, name="delete_shifttype"),
          path("add-shifttype/", views.add_shifttype, name="add_shifttype"),







         path("position/export/pdf/", views.export_position_pdf, name="export_position_pdf"),
    path("position/export/excel/", views.export_position_excel, name="export_position_excel"),

             path("employee/export/pdf/", views.export_employee_pdf, name="export_employee_pdf"),
    path("employee/export/excel/", views.export_employee_excel, name="export_employee_excel"),

      path('edit-role/', views.edit_role, name='edit_role'),


    path("roles/add/", views.add_role, name="add_role"),
     path('delete-role/', views.delete_role, name='delete_role'),
     path('employee/delete/', views.delete_employee, name='delete_employee'),
         path('add-holiday/', views.add_holiday_ajax, name='add_holiday_ajax'),
             path('update-holiday/', views.update_holiday_ajax, name='update_holiday_ajax'),

                 path('delete_holiday/', views.delete_holiday, name='delete_holiday'),



        path('', views.index),
          path('emp/', views.emp),
                path('login/', views.login_),
            path('employeelist/', views.employeelist),
                  path('employeegird/', views.employeegird),
                    path('edetails/<str:data>/', views.edetails,name="edetails"),
                    path('department/', views.department),
                     path('designation/', views.designation),
                       path('ticket/', views.ticket),
                         path('ticketdetail/', views.ticketdetail),
                          path('holiday/', views.holiday),
                              path('set-under/', views.set_under, name='set_under'),
                                 path('leave/', views.leave),
                                  path("advance-salary/request/", views.request_advance_salary, name="request_advance_salary"),
                                  path("advance-salary/delete/<int:id>/", views.delete_advance_salary, name="delete_advance_salary"),



                                                    path('advancesalary/', views.advancesalary),
                                          path('leavesetting/', views.leavesetting),
                                                 path('attendence/<str:data>/', views.attendence),
                                                       path('attendence/', views.attendence),
                                                         path('submit-leave/', views.submit_leave, name='submit_leave'),
                                                         path('leave/update-status/', views.update_leave_status, name='update_leave_status'),
path("advance/update-status/", views.update_advance_salary_status, name="update_advance_salary_status"),


                                                  path('timesheet/', views.timesheet),
                                                             path('salarylist/', views.salarylist,name="salarylist"),
                                                             # urls.py
path("generate-salary/", views.generate_salary_ajax, name="generate-salary"),

                                                     path('shift/', views.shift),
                                                       path('resignation/', views.resignation),
                                                                            path('termination/', views.termination),
                                                                                    path('salaryslip/', views.salaryslip),
                                                                                     path('payslip/', views.payslip),
                                                                                      path('users/', views.users),
                                                                                          path('roles/', views.roles),
                                                                                            path('profile/', views.profile,name='profile_update'),
                                                                                              path('addattendence/', views.addattendence),
                                                                                                  path('get-employee-shift/', views.get_employee_shift, name='get_employee_shift'),
                                                                                                  path('get-attendance-shift/', views.get_attendance_shift, name='get_attendance_shift'),
path('save-attendance/', views.save_attendance, name='save_attendance'),
path('attendance/pdf/', views.attendance_pdf, name='attendance_pdf'),

]
if settings.DEBUG:  # Serve media only in dev
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)