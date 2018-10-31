## 1. Select FileMerge as the command Xcode active config
`sudo xcode-select -s /Applications/Xcode.app/Contents/Developer`

## 2. Select git diff tool
`git config --global diff.external opendiff "$2" "$5" -merge "$1"`

## 3. Shell Colors
    Black        0;30     Dark Gray     1;30
    Red          0;31     Light Red     1;31
    Green        0;32     Light Green   1;32
    Brown/Orange 0;33     Yellow        1;33
    Blue         0;34     Light Blue    1;34
    Purple       0;35     Light Purple  1;35
    Cyan         0;36     Light Cyan    1;36
    Light Gray   0;37     White         1;37

## 4. Heroku Commands
    heroku create <hostname> => hostname.herokuapp.com
    heroku ps:scale web=1
    heroku open
    git push heroku master

## 5. Install nvm

    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
    https://github.com/creationix/nvm

## 6. Install rvm

    TODO

## 7. Install brew

    TODO

## 8. Terminal Shortcuts
- Option  + Left or Right: Navigate through words
- Control + W: Delete word before cursor
- Escape  + T: Swap words before cursor
- Control + R: Previously used command
- Control + A: Home
- Control + E: End
- Control + U: Clear text before cursor
- Control + K: Clear text after cursor
- Control + D: Exit the terminal
- Control + Z: Send process to background
- Command + K: Clear screen
- Command + L: Clear line

## 9. Lombok
@AllArgsConstructor
@EqualsAndHashCode
@ToString
@Getter
@Setter
@Builder
@Data
@Slf4j

## 10. application-it.properties
spring.datasource.driver-class-name=org.h2.Driver
spring.datasource.username=sa
spring.datasource.password=
spring.jpa.generate-ddl=false
spring.jpa.hibernate.ddl-auto=validate
spring.h2.console.enabled=true
spring.h2.console.path=/h2DB
spring.datasource.platform=h2
spring.datasource.url=jdbc:h2:mem:SCHEMA;MODE=Postgres;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
spring.jpa.show-sql=true

## WIZLAIR
    https://archive.org/details/msdos_shareware_fb_WIZLAIR