<ul class="posts-index">
{{range .Data.writing.pages}}
<li class="post-link"><a href="{{print  "/writing/" .slug}}"><span class="date">{{.formatteddate}}</span>  <span>{{.title}}</span></a></li>
{{end}}
</ul>
