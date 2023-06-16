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
    /** Человекочитаемое название параметра (можно отдавать пользователю)**/
    2: required string name
    3: required ParameterType type 
}

/** Тип параметра, позволяет производить простую валидацию данных на клиенте **/
enum ParameterType {
    bl
    integer
    fl
    str
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
    2: required ParameterValue type 
}

/** Значение параметра **/
union ParameterValue {
    1: bool bl
    2: i64 integer
    3: double fl
    4: string str
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