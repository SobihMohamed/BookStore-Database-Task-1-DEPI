# BookStore SQL Database

## Description

This project is a relational database design and implementation for an online bookstore. It handles books, authors, categories, customers, and order processing. The schema is designed with data integrity in mind, ensuring prices and stock levels cannot be negative, email addresses remain unique, and historical pricing is preserved in order records regardless of future price changes.

```mermaid
erDiagram
    CATEGORIES ||--o{ BOOKS : contains
    AUTHORS ||--o{ BOOKS : writes
    BOOKS ||--o{ ORDER_ITEMS : includes
    CUSTOMERS ||--o{ ORDERS : places
    ORDERS ||--o{ ORDER_ITEMS : contains

    CATEGORIES {
        int CategoryID PK
        varchar CategoryName
    }
    AUTHORS {
        int AuthorID PK
        varchar AuthorName
    }
    BOOKS {
        int BookID PK
        varchar Title
        int AuthorID FK
        int CategoryID FK
        decimal Price
        int Stock
        bit IsActive
    }
    CUSTOMERS {
        int CustomerID PK
        varchar FullName
        varchar Email
        varchar City
    }
    ORDERS {
        int OrderID PK
        int CustomerID FK
        datetime OrderDate
    }
    ORDER_ITEMS {
        int OrderItemID PK
        int OrderID FK
        int BookID FK
        int Quantity
        decimal UnitPrice
    }
```
