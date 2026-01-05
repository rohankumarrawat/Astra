from django import template
from manager.models import RolePermission  # adjust if RolePermission is in another app

register = template.Library()

@register.simple_tag(takes_context=True)
def has_permission(context, permission_name):
    user = context['request'].user
    if user.is_authenticated:
        if user.is_superuser:
            return True
        try:
            employee = user.employee
            return RolePermission.objects.filter(role=employee.role, permission__name=permission_name).exists()
        except Exception:
            return False
    return False