<ul>
{{range .Data.writing.pages}}
<li><a href="{{print  "/writing/" .slug}}">{{.formatteddate}} - {{.title}}</a></li>
{{end}}
</ul>
