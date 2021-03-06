﻿
&НаКлиенте
Процедура КомандаНастройки(Команда)
	ОткрытьФорму("Обработка.узТекущиеДела.Форма.ФормаНастройки",,ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура КомандаОбновить(Команда)
	ОбновитьТекущиеДелаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьТекущиеДелаНаСервере()
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	пОбъект.ОбновитьНаСервере();
	ЗначениеВРеквизитФормы(пОбъект,"Объект");	
КонецПроцедуры 

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Объект.НаДату = ТекущаяДата();
	Объект.НаДатуКонецДня = КонецДня(Объект.НаДату);
	Объект.ПоказыватьСегодня = Истина;
	Объект.ПоказыватьНаНеделе = Истина;
	Объект.ПоказыватьПозже = Истина;
	ЗаполнитьТекущиеДелаНаСервере();
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьДоступность()
	Элементы.ГруппаДопСведения.Видимость = Ложь;
	Элементы.ТЧТекущиеДелаГруппаЗадачаНомерЗадачи.Видимость = Ложь;
	Элементы.ТЧТекущиеДелаВопрос.Видимость = Ложь;
	
	Если ПоказыватьДопСведения Тогда
		Элементы.ГруппаДопСведения.Видимость = Истина;
	Иначе
		Элементы.ТЧТекущиеДелаГруппаЗадачаНомерЗадачи.Видимость = Истина;
		Элементы.ТЧТекущиеДелаВопрос.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьТекущиеДелаНаСервере()
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	пОбъект.ЗаполнитьТекущиеДела();
	ЗначениеВРеквизитФормы(пОбъект,"Объект");
КонецПроцедуры 

&НаСервере
Процедура СохранитьТекущиеДелаНаСервере()
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	пОбъект.СохранитьТекущиеДела();
	ЗначениеВРеквизитФормы(пОбъект,"Объект");
КонецПроцедуры 

&НаКлиенте
Процедура ПриЗакрытии()
	ПриЗакрытииНаСервере();
	
	Если Объект.АвтоматическиСохранятьТекущиеДела Тогда
		ОтключитьОбработчикОжидания("СохранитьТекущиеДелаНаКлиенте");
	Конецесли;
КонецПроцедуры


&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьТекущиеДелаНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ТЧТекущиеДелаПриИзменении(Элемент)
	СтрокаТЧТекущиеДела = Элемент.ТекущиеДанные;
	Если СтрокаТЧТекущиеДела <> Неопределено Тогда
		СтрокаТЧТекущиеДела.Порядок = СтрокаТЧТекущиеДела.НомерСтроки;
	Конецесли;
КонецПроцедуры


&НаКлиенте
Процедура НаДатуПриИзменении(Элемент)
	ЗаполнитьТекущиеДелаНаСервере();
КонецПроцедуры


&НаСервере
Процедура ТЧТекущиеДелаПередУдалениемНаСервере(МассивТекущихДел)
	пОбъект = РеквизитФормыВЗначение("Объект"); 
	пОбъект.УбратьТекущееДело(МассивТекущихДел);
	ЗначениеВРеквизитФормы(пОбъект,"Объект");
КонецПроцедуры


&НаКлиенте
Процедура ТЧТекущиеДелаПередУдалением(Элемент, Отказ)
	Отказ = Истина;

	МассивВыделенныхСтрок = Элемент.ВыделенныеСтроки;	
	Если МассивВыделенныхСтрок.Количество() = 0 Тогда
		Возврат;
	Конецесли;
	
	МассивТекущихДел = ПолучитьМассивТекущихДелПоВыделеннымСтрокам(МассивВыделенныхСтрок);
	ТекстВопроса = "ВНИМАНИЕ! Вы точно хотите удалить текущие дела: " + Символы.ПС;
	
	Для каждого пТекущееДело из МассивТекущихДел цикл
		ТекстВопроса = ТекстВопроса + Символы.ПС
			+ "* "+пТекущееДело;
	Конеццикла;
	ТекстВопроса = ТекстВопроса + Символы.ПС
		+ "Продолжить?";
	
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("МассивТекущихДел",МассивТекущихДел);
	
	ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПослеЗакрытияВопросаТЧТекущиеДелаПередУдалением", ЭтаФорма, ДопПараметры);
	
	ПоказатьВопрос(ОповещениеОЗакрытии,ТекстВопроса,РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаТЧТекущиеДелаПередУдалением(Результат, ДопПараметры) Экспорт
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
	КонецЕсли;
		
	МассивТекущихДел = ДопПараметры.МассивТекущихДел;
	ТЧТекущиеДелаПередУдалениемНаСервере(МассивТекущихДел);
	
КонецПроцедуры 



&НаКлиенте
Функция ПолучитьМассивТекущихДелПоВыделеннымСтрокам(МассивВыделенныхСтрок)
	МассивТекущихДел = Новый Массив();
	Для каждого ЭлМассиваВыделенныхСтрок из МассивВыделенныхСтрок цикл
		ИдентификаторСтроки = ЭлМассиваВыделенныхСтрок;
		
		СтрокаТЧТекущиеДела = Объект.ТЧТекущиеДела.НайтиПоИдентификатору(ИдентификаторСтроки);
		пТекущееДело = СтрокаТЧТекущиеДела.ТекущееДело;
		МассивТекущихДел.Добавить(пТекущееДело);
	Конеццикла;	
	Возврат МассивТекущихДел;
КонецФункции


&НаКлиенте
Процедура КомандаВыполнил(Команда)
	МассивВыделенныхСтрок = Элементы.ТЧТекущиеДела.ВыделенныеСтроки;
	Для каждого ЭлМассиваВыделенныхСтрок из МассивВыделенныхСтрок цикл
	    ИдентификаторСтроки = ЭлМассиваВыделенныхСтрок;
		
		СтрокаТЧТекущиеДела = Объект.ТЧТекущиеДела.НайтиПоИдентификатору(ИдентификаторСтроки);			
		Если СтрокаТЧТекущиеДела.Выполнено Тогда
			Продолжить;
		Конецесли;
		СтрокаТЧТекущиеДела.ДатаВыполнения = ТекущаяДата();
		СтрокаТЧТекущиеДела.Выполнено = Истина;
	Конеццикла;	
	
	ОбновитьТекущиеДелаНаСервере();
	//
	//Для каждого СтрокаТЧТекущиеДела из Объект.ТЧТекущиеДела цикл
	//	пПорядокДоп = ПолучитьПорядоДопНаКлиенте(СтрокаТЧТекущиеДела.Выполнено,СтрокаТЧТекущиеДела.ДатаВыполнения,Объект.НаДату);	
	//	СтрокаТЧТекущиеДела.ПорядокДоп = пПорядокДоп;	
	//Конеццикла;
	//
	//Объект.ТЧТекущиеДела.Сортировать("ПорядокДоп,Порядок");
КонецПроцедуры

&НаКлиенте
Функция ПолучитьПорядоДопНаКлиенте(пВыполнено,пДатаВыполнения,пНаДату) 
	Возврат ПолучитьПорядоДопНаСервере(пВыполнено,пДатаВыполнения,пНаДату);
	////Такая же функция есть в модуле обработки
	//пПорядокДоп = 10;
	//Если НЕ пВыполнено Тогда
	//	пПорядокДоп = 0;
	//Иначе
	//	Если НачалоДня(пДатаВыполнения) <> пНаДату Тогда
	//		пПорядокДоп = 1;
	//	Иначе
	//		пПорядокДоп = 2;
	//	Конецесли;
	//Конецесли;
	//Возврат пПорядокДоп;
КонецФункции 

&НаСервереБезКонтекста
Функция ПолучитьПорядоДопНаСервере(пВыполнено,пДатаВыполнения,пНаДату)
	Возврат Справочники.узТекущиеДела.ПолучитьПорядоДоп(пВыполнено,пДатаВыполнения,пНаДату);	
КонецФункции 

&НаКлиенте
Процедура КомандаПоказатьДопСведения(Команда)
	ПоказыватьДопСведения = НЕ ПоказыватьДопСведения;
	Элементы.ТЧТекущиеДелаКомандаПоказатьДопСведения.Пометка = ПоказыватьДопСведения;
	УстановитьВидимостьДоступность();
КонецПроцедуры


&НаКлиенте
Процедура ТЧТекущиеДелаТекстСодержанияПриИзменении(Элемент)
		
КонецПроцедуры

&НаКлиенте
Процедура КомандаПредыдущийПериод(Команда)
	НаДатуНовая = ПолучитьНаДатуНовая(-1);
	ИзменитьНаДату(НаДатуНовая);
КонецПроцедуры

&НаКлиенте
Процедура КомандаНаДату(Команда)
	НаДатуНовая = НачалоДня(ТекущаяДата());
	ИзменитьНаДату(НаДатуНовая);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокКомандаНаДату()
	пЗаголовок = "";
	Если НачалоДня(Объект.НаДату) = НачалоДня(ТекущаяДата()) Тогда
		пЗаголовок = "Сегодня";
	Иначе
		пЗаголовок = Формат(Объект.НаДату,"ДФ='dd.MM ддд'");
	Конецесли;
	Элементы.ТЧТекущиеДелаКомандаНаДату.Заголовок = пЗаголовок;
КонецПроцедуры 

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьЗаголовокКомандаНаДату();
	
	Если Объект.АвтоматическиСохранятьТекущиеДела Тогда
		ПодключитьОбработчикОжидания("СохранитьТекущиеДелаНаКлиенте", 600);
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьНаДату(НаДатуНовая)
	Объект.НаДату = НаДатуНовая;
	Объект.НаДатуКонецДня = КонецДня(Объект.НаДату);
	ОбновитьТекущиеДелаНаСервере();
	ОбновитьЗаголовокКомандаНаДату();	
КонецПроцедуры 

&НаКлиенте
Функция ПолучитьНаДатуНовая(Сдвиг) 
	Если Сдвиг =  1 Тогда
		НаДатуНовая = НачалоДня(КонецДня(Объект.НаДату) + 1);
	Иначе
		НаДатуНовая = НачалоДня(Объект.НаДату - 1);
	Конецесли;
	//Если НаДатуНовая > ТекущаяДата() Тогда
	//	НаДатуНовая = Объект.НаДату;	
	//Конецесли;
	
	Возврат НаДатуНовая;
КонецФункции 

&НаКлиенте
Процедура КомандаСледующийПериод(Команда)
	НаДатуНовая = ПолучитьНаДатуНовая(1);
	ИзменитьНаДату(НаДатуНовая);
КонецПроцедуры

&НаКлиенте
Процедура ТЧТекущиеДелаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока Тогда
		СтрокаТЧТекущиеДела = Элемент.ТекущиеДанные;
		СтрокаТЧТекущиеДела.ДатаСоздания = ТекущаяДата();
		СтрокаТЧТекущиеДела.ДатаТекущегоДела = СтрокаТЧТекущиеДела.ДатаСоздания;
		СтрокаТЧТекущиеДела.Порядок = СтрокаТЧТекущиеДела.НомерСтроки;
		СтрокаТЧТекущиеДела.ГруппаТекущегоДела = ПредопределенноеЗначение("Справочник.узГруппыТекущихДел.Сегодня");
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "КомандаДобавитьВТекущиеДела" Тогда
		ОбновитьТекущиеДелаНаСервере();		
	Конецесли;
КонецПроцедуры

&НаКлиенте
Процедура КомандаСохранить(Команда)
	СохранитьТекущиеДелаНаКлиенте();	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьТекущиеДелаНаКлиенте()
	СохранитьТекущиеДелаНаСервере();	
КонецПроцедуры 

&НаКлиенте
Процедура ПоказыватьСегодняПриИзменении(Элемент)
	ОбновитьТекущиеДелаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьНаНеделеПриИзменении(Элемент)
	ОбновитьТекущиеДелаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПоказыватьПозжеПриИзменении(Элемент)
	ОбновитьТекущиеДелаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура АвтоматическиСохранятьТекущиеДелаПриИзменении(Элемент)
	ПрименитьНастройкиНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ПрименитьНастройкиНаКлиенте() Экспорт
	Если Объект.АвтоматическиСохранятьТекущиеДела Тогда
		ПодключитьОбработчикОжидания("СохранитьТекущиеДелаНаКлиенте", 600);
	Иначе
		ОтключитьОбработчикОжидания("СохранитьТекущиеДелаНаКлиенте");		
	Конецесли;	
КонецПроцедуры 
