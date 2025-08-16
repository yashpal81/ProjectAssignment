/**
 * @description Utility class to access Assignment Configuration settings
 */
public class AssignmentConfigUtil {
    private static Assignment_Config__c config;
    public static Assignment_Config__c getConfig() {
        if (config == null) {
            config = Assignment_Config__c.getInstance();
            if (config == null) {
                config = new Assignment_Config__c();
                config.Max_Tasks_Per_Day__c = 5;
                config.Default_Due_Days__c = 7;
                config.Email_Notifications__c = true;
                config.Max_Projects_Per_User__c = 3;
            }
        }
        return config;
    }
    public static Decimal getMaxTasksPerDay() { return getConfig().Max_Tasks_Per_Day__c; }
    public static Decimal getDefaultDueDays() { return getConfig().Default_Due_Days__c; }
    public static Boolean isEmailNotificationEnabled() { return getConfig().Email_Notifications__c; }
    public static Decimal getMaxProjectsPerUser() { return getConfig().Max_Projects_Per_User__c; }
    public static void logConfigValues() {
        Assignment_Config__c cfg = getConfig();
        System.debug('=== Assignment Configuration ===');
        System.debug('Max Tasks Per Day: ' + cfg.Max_Tasks_Per_Day__c);
        System.debug('Default Due Days: ' + cfg.Default_Due_Days__c);
        System.debug('Email Notifications: ' + cfg.Email_Notifications__c);
        System.debug('Max Projects Per User: ' + cfg.Max_Projects_Per_User__c);
        System.debug('================================');
    }
}
