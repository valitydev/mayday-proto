namespace java dev.vality.alerting.mayday

/** Идентификатор **/
typedef string ID

/** Информация об алерте конкретного пользователя */
struct UserAlert {
    1: required ID id
    /** Человекочитаемое название алерта (можно отдавать пользователю) **/
    2: required string name
}

/** Общая информация о шаблоне алерта, который доступен для создания **/
struct Alert {
    1: required ID id
    /** Человекочитаемое название шаблона (можно отдавать пользователю) **/
    2: required string name
}

/** Подробная конфигурация алерта, которую необходимо заполнить для создания алерта **/
struct AlertConfiguration {
    1: required ID id
    2: required list<ParameterConfiguration> parameters
}

/** Параметр, который необходимо передать для создания алерта **/
struct ParameterConfiguration {
    1: required ID id
    /** Человекочитаемое название параметра (можно отдавать пользователю) **/
    2: required string name
    /** Если параметр необязательный, пользователь может ничего не вводить и в таком случае информацию о вводе можно не передавать в mayday **/
    3: required bool mandatory
    /** Допустимые варианты значений, из которых должен выбирать пользователь **/
    4: optional list<string> options
    /** Регулярное выражение, с помощью которго можно провалидировать ввод пользователя **/
    5: optional string value_regexp
}

/** Заполненная конфигурация алерта */
struct CreateAlertRequest {
    1: required ID alert_id
    2: required ID user_id
    3: required list<ParameterInfo> parameters
}

/** Заполненная информация о параметре **/
struct ParameterInfo {
    1: required ID id
    2: required string value 
}

exception UserNotFound {}

exception AlertNotFound {}

exception InvalidParameterFormat {}


/**
* Интерфейс для управления алертингом
*/
service AlertingService {

     /** Удалить все алерты пользователя **/
    void DeleteAllAlerts (1: ID user_id) throws (1: UserNotFound ex);

    /** Удалить определенный алерт пользователя **/
    void DeleteAlert (1: ID user_id, 2: ID user_alert_id) throws (1: AlertNotFound ex);

    /** Получить список активных алертов пользователя **/
    list<UserAlert> GetUserAlerts (1: ID user_id) throws (1: UserNotFound ex);

    /** Получить список доступных для создания алертов **/
    list<Alert> GetSupportedAlerts ();

    /** Получить расширенную конфигурацию алерта **/
    AlertConfiguration GetAlertConfiguration (1: ID alert_id) throws (1: AlertNotFound ex);

    /** Создать алерт для пользователя **/
    void CreateAlert (1: CreateAlertRequest create_alert_request) throws (1: AlertNotFound ex1, 2: UserNotFound ex2, 3: InvalidParameterFormat ex3);

}